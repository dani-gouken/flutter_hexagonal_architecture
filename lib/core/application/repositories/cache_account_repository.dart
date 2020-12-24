import 'package:hexa/container.dart';
import 'package:hexa/core/application/collections/account_collection.dart';
import 'package:hexa/core/domain/exceptions/not_found_exception.dart';
import 'package:hexa/core/domain/models/account.dart';
import 'package:hexa/core/domain/repositories/account_repository.dart';
import 'package:hexa/core/domain/repositories/transaction_repository.dart';
import 'package:hexa/framework/persistence/i_persister.dart';

class CacheAccountRepository extends AccountRepository {
  IPersister _persister = use<IPersister>();
  TransactionRepository _transactionRepository = use<TransactionRepository>();

  AccountCollection _collection;
  CacheAccountRepository() {
    try {
      this._collection = AccountCollection().newFromPersister(_persister) ??
          AccountCollection();
    } catch (err) {
      this._collection = new AccountCollection();
    }
  }
  @override
  Future<Account> add(Account account) async {
    await Future.delayed(Duration(seconds: 5));
    _collection.add(account);
    _persister.persist(_collection);
    return account;
  }

  @override
  Future<List<Account>> findAll() async {
    await Future.delayed(Duration(seconds: 2));
    return _collection.accounts;
  }

  @override
  Future<Account> findByUuid(String uuid) async {
    try {
      return _collection.accounts.firstWhere((element) => element.uuid == uuid);
    } catch (err) {
      throw NotFoundException("Account not found");
    }
  }

  @override
  Future<void> remove(Account account) async {
    _collection.remove(account);
    await _transactionRepository.removeByAccount(account);
    _persister.persist(_collection);
  }

  @override
  Future<Account> update(Account account) async {
    _persister.persist(_collection);
    return account;
  }
}
