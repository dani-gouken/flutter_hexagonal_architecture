import 'package:uuid/uuid.dart';

enum TransactionType { DEPOSIT, WITHDRAWAL }

class Transaction {
  String uuid;
  String name;
  DateTime createdAt;
  double amount;
  String accountUuid;
  TransactionType type;
  bool get isDeposit => type == TransactionType.DEPOSIT;
  bool get isWithdrawal => type == TransactionType.WITHDRAWAL;

  Transaction(
      {String uuid,
      this.accountUuid,
      this.name,
      this.createdAt,
      this.amount,
      this.type}) {
    this.uuid = uuid ?? Uuid().v4();
  }
}
