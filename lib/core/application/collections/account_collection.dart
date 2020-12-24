import 'package:hexa/core/application/serializers/account_serializer.dart';
import 'package:hexa/core/domain/models/account.dart';
import 'package:hexa/framework/persistence/persistence.dart';

class AccountCollection extends JsonPersistable {
  List<Account> accounts = [];
  static const String KEY = "accounts";

  AccountCollection({accounts}) {
    this.accounts = accounts ?? [];
  }

  add(Account account) {
    this.accounts.add(account);
  }

  remove(Account account) {
    this.accounts.remove(account);
  }

  @override
  JsonSerializable fromJson(Map<String, dynamic> json) {
    List<dynamic> data = json["accounts"];
    List<Account> accounts = [];
    data.forEach((element) {
      accounts.add(AccountSerializer.deserialize(element));
    });
    return new AccountCollection(accounts: accounts);
  }

  @override
  String getPersistableKey() {
    return KEY;
  }

  @override
  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> data = [];
    accounts.forEach((element) {
      data.add(AccountSerializer.serialize(element));
    });
    return {"accounts": data};
  }
}
