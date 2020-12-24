import 'persistable.dart';

abstract class IPersister {
  persist(Persistable value);
  remove(Persistable persistable);
  bool has(String key);
  get(key, {defaultValue});
  getInstance();
}
