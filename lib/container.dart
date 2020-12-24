import 'package:get_it/get_it.dart';

class AppContainer {
  static AppContainer _instance;
  final container = GetIt.instance;
  AppContainer() {
    _instance = this;
  }

  static AppContainer get instance => _instance ?? AppContainer();
  static T resolve<T>() => instance.get<T>();

  T get<T>() => container.get<T>();

  set<T>(concrete) {
    if (container.isRegistered<T>()) {
      container.unregister<T>();
    }
    container.registerSingleton<T>(concrete);
    return this;
  }
}

T use<T>() {
  return AppContainer.resolve<T>();
}
