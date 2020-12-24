import 'package:hexa/core/domain/models/account.dart';

abstract class AccountRepository {
  Future<List<Account>> findAll();
  Future<Account> findByUuid(String uuid);
  Future<void> remove(Account account);
  Future<Account> add(Account account);
  Future<Account> update(Account account);
}
