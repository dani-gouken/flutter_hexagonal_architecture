import 'package:hexa/container.dart';
import 'package:hexa/core/application/collections/transaction_collection.dart';
import 'package:hexa/core/domain/exceptions/not_found_exception.dart';
import 'package:hexa/core/domain/models/account.dart';
import 'package:hexa/core/domain/models/transaction.dart';
import 'package:hexa/core/domain/repositories/transaction_repository.dart';
import 'package:hexa/framework/persistence/i_persister.dart';

class CacheTransactionRepository extends TransactionRepository {
  IPersister _persister = use<IPersister>();
  TransactionCollection _collection;
  CacheTransactionRepository() {
    try {
      this._collection = TransactionCollection().newFromPersister(_persister) ??
          TransactionCollection();
    } catch (err) {
      this._collection = TransactionCollection();
    }
    _persistCollection();
  }

  _persistCollection() {
    _persister.persist(_collection);
  }

  @override
  Future<List<Transaction>> findAll() async {
    return _collection.transactions;
  }

  @override
  Future<Transaction> findByUuid(String uuid) async {
    try {
      return _collection.transactions
          .firstWhere((element) => element.uuid == uuid);
    } catch (err) {
      throw NotFoundException("Account not found");
    }
  }

  @override
  Future<List<Transaction>> findByAccount(Account account) async {
    try {
      return _collection.transactions
          .where((element) => element.accountUuid == account.uuid)
          .toList();
    } catch (err) {
      throw NotFoundException("Account not found");
    }
  }

  @override
  Future<List<Transaction>> findLatest() async {
    return _collection.transactions.take(5).toList();
  }

  @override
  Future<Transaction> report(Transaction transaction, Account account) async {
    transaction.accountUuid = account.uuid;
    transaction.createdAt = DateTime.now();
    if (transaction.isDeposit) {
      account.deposit(transaction.amount);
    } else {
      account.withdraw(transaction.amount);
    }
    _collection.add(transaction);
    _persistCollection();
    await Future.delayed(Duration(seconds: 2));
    return transaction;
  }

  @override
  Future<void> removeByAccount(Account account) async {
    _collection.transactions
        .removeWhere((element) => element.accountUuid == account.uuid);
    _persistCollection();
    return;
  }
}
