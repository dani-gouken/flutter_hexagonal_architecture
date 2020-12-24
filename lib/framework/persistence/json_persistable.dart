import 'dart:convert';
import './i_persister.dart';

import './persistable.dart';
import 'json_serializable.dart';

abstract class JsonPersistable implements Persistable, JsonSerializable {
  @override
  String getPersistableValue() {
    return jsonEncode(this.toJson());
  }

  @override
  newFromPersister(IPersister persister) {
    if (!persister.has(this.getPersistableKey())) {
      return null;
    }
    String jsonString = persister.get(this.getPersistableKey());
    try {
      return this.fromJson(jsonDecode(jsonString));
    } catch (err) {
      rethrow;
    }
  }
}
