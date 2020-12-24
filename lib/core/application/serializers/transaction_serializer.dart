import 'package:hexa/core/domain/models/transaction.dart';

class TransactionSerializer {
  static Map<String, dynamic> serialize(Transaction transaction) {
    return {
      "uuid": transaction.uuid,
      "name": transaction.name,
      "amount": transaction.amount,
      "type": transaction.type.toString(),
      "account_uuid": transaction.accountUuid,
      "createdAt": transaction.createdAt.millisecondsSinceEpoch
    };
  }

  static Transaction deserialize(Map<String, dynamic> json) {
    return Transaction(
        uuid: json["uuid"],
        amount: json["amount"],
        name: json["name"],
        accountUuid: json["account_uuid"],
        type: json["type"] == TransactionType.DEPOSIT.toString()
            ? TransactionType.DEPOSIT
            : TransactionType.WITHDRAWAL,
        createdAt: DateTime.fromMillisecondsSinceEpoch(json["createdAt"]));
  }
}
