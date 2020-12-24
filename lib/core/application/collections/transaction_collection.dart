import 'package:hexa/core/application/serializers/transaction_serializer.dart';
import 'package:hexa/core/domain/models/transaction.dart';
import 'package:hexa/framework/persistence/persistence.dart';

class TransactionCollection extends JsonPersistable {
  List<Transaction> transactions = [];
  static const String KEY = "transactions";

  TransactionCollection({List<Transaction> transactions}) {
    this.transactions = transactions ?? [];
  }

  add(Transaction transaction) {
    this.transactions.insert(0, transaction);
  }

  remove(Transaction transaction) {
    this.transactions.remove(transaction);
  }

  @override
  JsonSerializable fromJson(Map<String, dynamic> json) {
    List<dynamic> data = json["transactions"];
    List<Transaction> cachedTransactions = [];
    data.forEach((element) {
      cachedTransactions.add(TransactionSerializer.deserialize(element));
    });
    return new TransactionCollection(transactions: cachedTransactions);
  }

  @override
  String getPersistableKey() {
    return KEY;
  }

  @override
  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> data = [];
    transactions.forEach((element) {
      data.add(TransactionSerializer.serialize(element));
    });
    return {"transactions": data};
  }
}
