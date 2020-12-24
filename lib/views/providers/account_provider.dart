import 'package:hexa/core/domain/models/account.dart';
import 'package:hexa/core/domain/repositories/account_repository.dart';
import 'package:hexa/framework/state_machine/state_machine.dart';

import '../../container.dart';

class AccountProvider extends TaskAwareChangeNotifier {
  AccountRepository repository = use<AccountRepository>();
  Task loadAccountsTask = useTask("load.accounts");
  Task createdAccountsTask = useTask("create.accounts");

  List<Account> _accounts = [];
  List<Account> get accounts => _accounts;
  double get balance {
    double result = 0.0;
    _accounts.forEach((element) => result += element.balance);
    return result;
  }

  AccountProvider() {
    _loadAccounts();
  }
  void loadAccount() => _loadAccounts();
  _loadAccounts() {
    runAndNotify<List<Account>>(loadAccountsTask, repository.findAll())
        .then((value) {
      _accounts = value;
      notifyListeners();
    });
  }

  Future<Account> add(Account account) async {
    return runAndNotify(createdAccountsTask, repository.add(account))
        .then((created) {
      notifyListeners();
      return;
    });
  }

  Future<void> remove(Account account) async {
    _accounts.remove(account);
    repository.remove(account);
    notifyListeners();
  }

  Future<void> update(Account account) async {
    repository.update(account);
    notifyListeners();
  }

  @override
  void dispose() {
    createdAccountsTask.dispose();
    loadAccountsTask.dispose();
    super.dispose();
  }
}
