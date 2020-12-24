import 'package:shared_preferences/shared_preferences.dart';

import 'i_persister.dart';
import 'persistable.dart';

class PrefsPersister extends IPersister {
  final SharedPreferences _prefs;
  PrefsPersister(this._prefs);
  @override
  getInstance() {
    return _prefs;
  }

  @override
  bool has(String key) {
    return _prefs.containsKey(key);
  }

  @override
  persist(Persistable persistable) {
    dynamic value = persistable.getPersistableValue();
    String key = persistable.getPersistableKey();
    if (value is String) {
      _prefs.setString(key, value);
      return;
    }
    if (value is bool) {
      _prefs.setBool(key, value);
      return;
    }
    if (value is int) {
      _prefs.setInt(key, value);
      return;
    }
    if (value is double) {
      _prefs.setDouble(key, value);
      return;
    }
    if (value is List<String>) {
      _prefs.setStringList(key, value);
      return;
    }
    throw Exception(
        'The value of type [${value.runtimeType.toString()}] is not supported by the Prefs Persister');
  }

  @override
  remove(Persistable persistable) {
    _prefs.remove(persistable.getPersistableKey());
  }

  @override
  get(key, {defaultValue}) {
    return _prefs.get(key) ?? defaultValue;
  }
}
