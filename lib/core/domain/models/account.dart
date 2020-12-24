import 'package:hexa/core/domain/exceptions/invalid_operation_exeption.dart';
import 'package:uuid/uuid.dart';

class Account {
  String name;
  String uuid;
  double balance;

  Account({this.name, this.balance, String uuid}) {
    this.uuid = uuid ?? Uuid().v4();
  }

  deposit(double amount) {
    this.balance += amount;
  }

  withdraw(double amount) {
    if (balance <= 0) {
      throw new InvalidOperationException(
          "Withdraw are not allowed with an empty balance");
    }
    if (balance <= amount) {
      throw new InvalidOperationException(
          "The amount that you want to withdraw is more than the account balance");
    }
    this.balance -= amount;
  }
}
