import 'package:hexa/core/domain/models/account.dart';

class AccountSerializer {
  static Map<String, dynamic> serialize(Account account) {
    return {
      "uuid": account.uuid,
      "balance": account.balance,
      "name": account.name
    };
  }

  static Account deserialize(Map<String, dynamic> json) {
    return Account(
        name: json["name"], balance: json["balance"], uuid: json["uuid"]);
  }
}
