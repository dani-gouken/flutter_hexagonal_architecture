import 'package:flutter/foundation.dart';
import 'package:state_machine/state_machine.dart' as machine;

import 'machine.dart';

enum TaskState { isBusy, isIdle, isFailure, isCompleted }

enum TaskTransition { busy, idle, failed, completed }

class Task extends Machine {
  dynamic error;

  Function(machine.StateChange) onComplete;
  Function(machine.StateChange) onFailure;
  Function(machine.StateChange) onBusy;
  Function(machine.StateChange) onIdle;
  Function(machine.StateChange) onChange;

  Task(String machineName,
      {this.onComplete,
      this.onFailure,
      this.onBusy,
      this.onIdle,
      this.onChange})
      : super(machineName);
  @override
  init() {
    this.newState(TaskState.isBusy, onEnter: (e) {
      error = null;
      _notify(e, onBusy);
    });
    this.newState(TaskState.isCompleted, onEnter: (e) {
      _notify(e, onComplete);
    });
    this.newState(TaskState.isFailure, onEnter: (e) {
      var err = e.payload;
      this.error = err;
      _notify(e, onFailure);
      throw err;
    });
    this.newState(TaskState.isIdle, onEnter: (e) {
      _notify(e, onIdle);
    });

    this.newTransition(TaskTransition.busy,
        from: [
          TaskState.isIdle,
          TaskState.isFailure,
          TaskState.isCompleted,
        ],
        to: TaskState.isBusy);

    this.newTransition(TaskTransition.idle,
        from: [
          TaskState.isBusy,
          TaskState.isFailure,
          TaskState.isCompleted,
        ],
        to: TaskState.isIdle);

    this.newTransition(TaskTransition.failed,
        from: [
          TaskState.isBusy,
          TaskState.isIdle,
        ],
        to: TaskState.isFailure);

    this.newTransition(TaskTransition.completed,
        from: [
          TaskState.isBusy,
          TaskState.isIdle,
        ],
        to: TaskState.isCompleted);
  }

  _run(machine.StateChange e, Function(machine.StateChange) cb) {
    if (cb != null) {
      cb(e);
    }
  }

  _notify(machine.StateChange e, Function(machine.StateChange) cb) {
    _run(e, onChange);
    _run(e, cb);
  }

  bool get isOngoing => state(TaskState.isBusy);
  bool get isCompleted => state(TaskState.isCompleted);
  bool get hasFailed => state(TaskState.isFailure);
  bool get isIdle => state(TaskState.isIdle);

  Future<T> run<T>(Future task, {bool alreadyBusy = false}) async {
    if (currentState != getState(TaskState.isBusy)) {
      transitionTo(TaskTransition.busy);
    }
    return task.then((v) {
      transitionTo(TaskTransition.completed, v);
      return v as T;
    }).catchError((err) {
      transitionTo(TaskTransition.failed, err);
      throw err;
    });
  }
}

Task useTask(String machineName,
    {TaskState startingState = TaskState.isIdle,
    Function(machine.StateChange) onComplete,
    Function(machine.StateChange) onFailure,
    Function(machine.StateChange) onBusy,
    Function(machine.StateChange) onIdle,
    Function(machine.StateChange) onChange}) {
  Task machine = Task(machineName,
      onComplete: onComplete,
      onFailure: onFailure,
      onBusy: onBusy,
      onIdle: onIdle,
      onChange: onChange);
  machine.start(startingState);
  return machine;
}

abstract class TaskAwareChangeNotifier with ChangeNotifier {
  Future<T> runAndNotify<T>(Task task, Future future) {
    task.onChange = (e) {
      notifyListeners();
    };
    return run<T>(task, future);
  }

  Future<T> run<T>(Task task, Future future) {
    return task.run<T>(future);
  }

  setup() {}
}
