import 'package:hexa/core/domain/models/account.dart';
import 'package:hexa/core/domain/models/transaction.dart';

abstract class TransactionRepository {
  Future<List<Transaction>> findLatest();
  Future<List<Transaction>> findAll();
  Future<List<Transaction>> findByAccount(Account account);
  Future<Transaction> findByUuid(String uuid);
  Future<Transaction> report(Transaction transaction, Account account);

  Future<void> removeByAccount(Account account);
}
