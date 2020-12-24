import 'i_persister.dart';

abstract class Persistable {
  String getPersistableKey();
  getPersistableValue();
  newFromPersister(IPersister persister);
}
