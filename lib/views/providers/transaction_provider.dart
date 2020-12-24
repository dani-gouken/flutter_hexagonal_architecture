import 'package:hexa/core/domain/models/account.dart';
import 'package:hexa/core/domain/models/transaction.dart';
import 'package:hexa/core/domain/repositories/transaction_repository.dart';
import 'package:hexa/framework/state_machine/state_machine.dart';
import 'package:hexa/views/providers/account_provider.dart';

import '../../container.dart';

class TransactionProvider extends TaskAwareChangeNotifier {
  TransactionRepository repository = use<TransactionRepository>();
  List<Transaction> _lastestTransactions = [];
  List<Transaction> get lastestTransactions => _lastestTransactions;

  Task reportTransactionTask = useTask("report.transaction");
  Task loadLatestTransactionTask = useTask("load.lastest.transaction");

  AccountProvider accountProvider;
  TransactionProvider update(AccountProvider accountProvider) {
    this.accountProvider = accountProvider;
    _loadTransactions();
    return this;
  }

  void _loadTransactions() async {
    runAndNotify(loadLatestTransactionTask, Future.sync(() async {
      await Future.delayed(Duration(seconds: 4));
      return await repository.findLatest();
    })).then((value) {
      this._lastestTransactions = value;
      loadLatestTransactionTask.transitionTo(TaskTransition.idle);
      notifyListeners();
    });
  }

  Future<void> report(Transaction transaction, Account account) async {
    await runAndNotify(reportTransactionTask, Future.sync(() async {
      await repository.report(transaction, account);
      await this.accountProvider.update(account);
    })).then((value) {
      this.accountProvider.loadAccount();
      notifyListeners();
      _loadTransactions();
      return;
    });
  }

  Future<void> remove(Account account) async {
    repository.removeByAccount(account);
    notifyListeners();
    this.accountProvider.loadAccount();
    _loadTransactions();
  }

  @override
  void dispose() {
    super.dispose();
    reportTransactionTask.dispose();
    loadLatestTransactionTask.dispose();
  }
}
