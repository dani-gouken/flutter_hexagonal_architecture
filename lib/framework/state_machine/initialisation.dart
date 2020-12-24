import 'package:state_machine/state_machine.dart';

import 'state_machine.dart';

enum InitializationState { isInitialized, isNotInitialized, isFailure }

enum InitializationTransitions { initialize, cancel }

class Initialization extends Machine {
  Function(StateChange e) onInitialize;
  Function(StateChange e) onNotInitialize;
  Function(StateChange e) onFailure;
  Function(StateChange e) onChange;

  String name;
  Initialization(this.name,
      {this.onInitialize, this.onNotInitialize, this.onFailure, this.onChange})
      : super(name) {
    this.newState(InitializationState.isInitialized, onEnter: (e) {
      _notify(e, onInitialize);
    });
    this.newState(InitializationState.isNotInitialized, onEnter: (e) {
      _notify(e, onNotInitialize);
    });
    this.newState(InitializationState.isFailure, onEnter: (e) {
      _notify(e, onFailure);
    });

    this.newTransition(InitializationTransitions.initialize,
        from: [InitializationState.isNotInitialized],
        to: InitializationState.isInitialized);
    this.newTransition(InitializationTransitions.cancel,
        from: [InitializationState.isNotInitialized],
        to: InitializationState.isFailure);
  }

  bool get hasFailed {
    return state(InitializationState.isFailure);
  }

  bool get isInitialized {
    return state(InitializationState.isInitialized);
  }

  bool get isNotInitialized {
    return state(InitializationState.isNotInitialized);
  }

  initialize() {
    return transitionTo(InitializationTransitions.initialize);
  }

  _run(StateChange e, Function(StateChange) cb) {
    if (cb != null) {
      cb(e);
    }
  }

  _notify(StateChange e, Function(StateChange) cb) {
    _run(e, onChange);
    _run(e, cb);
  }
}

Initialization useInitialization(String name,
    {InitializationState startingState = InitializationState.isNotInitialized,
    Function(StateChange) onInitialize,
    Function(StateChange) onNotInitialize,
    Function(StateChange) onFailure,
    Function(StateChange) onChange}) {
  var machine = new Initialization(name,
      onInitialize: onInitialize,
      onNotInitialize: onNotInitialize,
      onFailure: onFailure,
      onChange: onChange);
  machine.start(startingState);
  return machine;
}
