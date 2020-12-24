import 'package:hexa/core/domain/models/account.dart';
import 'package:hexa/core/domain/repositories/account_repository.dart';

class ApiAccountRepository extends AccountRepository {
  @override
  Future<Account> add(Account account) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future<List<Account>> findAll() {
    // TODO: implement findAll
    throw UnimplementedError();
  }

  @override
  Future<Account> findByUuid(String uuid) {
    // TODO: implement findByUuid
    throw UnimplementedError();
  }

  @override
  Future<void> remove(Account account) {
    // TODO: implement remove
    throw UnimplementedError();
  }

  @override
  Future<Account> update(Account account) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
