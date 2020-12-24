import 'package:bot_toast/bot_toast.dart';
import 'package:flui/flui.dart';
import 'package:flutter/material.dart';
import 'package:hexa/core/domain/models/account.dart';
import 'package:hexa/core/domain/models/transaction.dart';
import 'package:hexa/framework/routing/navigate.dart';
import 'package:hexa/views/providers/account_provider.dart';
import 'package:hexa/views/screens/report_transaction_screen.dart';
import 'package:hexa/views/widgets/accounts/create_account_screen.dart';
import 'package:hexa/views/widgets/app_scaffold.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  AccountScreen({Key key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backButton: true,
      actions: [
        IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.blue,
            ),
            onPressed: () {
              Navigate.to(CreateAccountScreen());
            })
      ],
      title: "My Accounts",
      body: Consumer<AccountProvider>(
        builder: (context, provider, _) {
          if (provider.loadAccountsTask.isOngoing) {
            return Center(child: CircularProgressIndicator());
          }
          if (provider.loadAccountsTask.hasFailed) {
            return Center(
              child: Text(provider.loadAccountsTask.error.toString()),
            );
          }
          return ListView.builder(
              itemCount: provider.accounts.length,
              itemBuilder: (context, i) {
                Account account = provider.accounts[i];
                return FLListTile(
                  leading: Icon(Icons.account_balance_wallet),
                  title: Text(account.name),
                  subtitle: Text("${account.balance} XAF"),
                  trailing: IconButton(
                      icon: Icon(
                        Icons.folder_open,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        _showActionSheet(account);
                      }),
                );
              });
        },
      ),
    );
  }

  void _showActionSheet(Account account) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 300,
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "${account.name} : ${account.balance} XAF",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )),
                SizedBox(
                  height: 16,
                ),
                FLFlatButton(
                    padding: EdgeInsets.all(16),
                    onPressed: () {
                      Navigate.to(
                          ReportTransactionScreen(
                              type: TransactionType.DEPOSIT, account: account),
                          replace: true);
                    },
                    color: Colors.blue,
                    child: Row(
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Report income",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    )),
                SizedBox(
                  height: 16,
                ),
                FLFlatButton(
                    padding: EdgeInsets.all(16),
                    onPressed: () {
                      Navigate.to(
                          ReportTransactionScreen(
                              type: TransactionType.WITHDRAWAL,
                              account: account),
                          replace: true);
                    },
                    color: Colors.redAccent,
                    child: Row(
                      children: [
                        Icon(
                          Icons.remove,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Report an expense",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    )),
                SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: FLFlatButton(
                      padding: EdgeInsets.all(8),
                      onPressed: () {
                        context.read<AccountProvider>().remove(account);
                        Navigate.back(context);
                        BotToast.showSimpleNotification(
                            title: "The account ${account.name} was deleted");
                      },
                      color: Colors.transparent,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.delete_forever,
                              color: Colors.red,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "Delete account",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      )),
                )
              ],
            ),
          );
        });
  }
}
