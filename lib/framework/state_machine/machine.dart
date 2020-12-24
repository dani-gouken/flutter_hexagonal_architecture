import 'package:flutter/foundation.dart';
import 'package:state_machine/state_machine.dart' as machine;
import 'package:state_machine/state_machine.dart';

class Machine {
  machine.StateMachine _inner;
  String machineName;
  Map<dynamic, machine.State> states = {};
  Map<dynamic, machine.StateTransition> transitions = {};
  Machine(this.machineName) {
    this._inner = new machine.StateMachine(machineName);
    init();
  }
  init() {}
  newState(name,
      {Function(StateChange event) onEnter,
      Function(StateChange event) onLeave}) {
    machine.State state = this._inner.newState(name.toString());
    if (onEnter != null) {
      state.onEnter.listen(onEnter);
    }
    if (onLeave != null) {
      state.onLeave.listen(onLeave);
    }
    states[name.toString()] = state;
  }

  machine.State getState(name) {
    return states[name.toString()];
  }

  machine.StateTransition getTransition(name) {
    return transitions[name.toString()];
  }

  void transitionTo(transitionName, [dynamic payload]) {
    getTransition(transitionName)(payload);
  }

  bool state(stateName) {
    return getState(stateName)();
  }

  machine.State get currentState => _inner.current;

  machine.StateTransition newTransition(name,
      {@required List<dynamic> from, @required to}) {
    machine.StateTransition transition = _inner.newStateTransition(
        name.toString(),
        List<machine.State>.from(from.map((e) => getState(e))),
        getState(to));
    transitions[name.toString()] = transition;
    return transition;
  }

  start(startingState) {
    _inner.start(getState(startingState));
  }

  dispose() {
    _inner.dispose();
  }
}

Machine createMachine(name, [List<dynamic> states]) {
  Machine machine = new Machine(name);
  if (states != null) {
    states.forEach((element) {
      machine.newState(element);
    });
  }
  return machine;
}
