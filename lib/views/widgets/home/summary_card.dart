import 'package:flui/flui.dart';
import 'package:flutter/material.dart';
import 'package:hexa/core/domain/models/account.dart';
import 'package:hexa/framework/routing/navigate.dart';
import 'package:hexa/views/providers/account_provider.dart';
import 'package:hexa/views/screens/account_screen.dart';
import 'package:hexa/views/widgets/accounts/create_account_screen.dart';
import 'package:provider/provider.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountProvider>(
      builder: (context, provider, _) => Card(
        color: Colors.lightBlue,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Container(
          height: 280,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Builder(builder: (context) {
              if (provider.loadAccountsTask.hasFailed) {
                return Text(
                  "We are unable to fetch your accounts, please try again later",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 38,
                      color: Colors.yellow.shade200),
                );
              }
              if (provider.loadAccountsTask.isOngoing) {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total current balance",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 16, color: Colors.grey.shade200),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: FLSkeleton(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(2),
                        height: 50,
                        width: 200,
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                          itemCount: 4,
                          itemBuilder: (context, i) {
                            return FLSkeleton(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(2),
                              height: 10,
                              width: 250,
                              type: FLSkeletonAnimationType.stretch,
                              stretchWidth: 100,
                            );
                          },
                          separatorBuilder: (context, i) => SizedBox(
                                height: 8,
                              )),
                    )
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total current balance",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade200),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      "${provider.balance ?? 0} XAF",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 38,
                          color: Colors.yellow.shade200),
                    ),
                  ),
                  Expanded(
                    child: Builder(builder: (context) {
                      if (provider.accounts.isEmpty) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "you don't have any accounts yet",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            FLFlatButton(
                              color: Color(0xFF0F4C81),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              expanded: true,
                              padding: EdgeInsets.all(16),
                              textColor: Colors.white,
                              child: Text('Create an account',
                                  textAlign: TextAlign.center),
                              onPressed: () =>
                                  Navigate.to(CreateAccountScreen()),
                            ),
                          ],
                        );
                      }
                      List<Account> usableAccounts =
                          provider.accounts.take(2).toList();
                      return ListView.separated(
                          itemCount: usableAccounts.length + 1,
                          itemBuilder: (context, i) {
                            if (i == usableAccounts.length) {
                              return Text(
                                "...",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              );
                            }
                            return SummaryCardRow(
                              account: usableAccounts[i],
                            );
                          },
                          separatorBuilder: (context, i) => SizedBox(
                                height: 8,
                              ));
                    }),
                  ),
                  FLFlatButton(
                    expanded: true,
                    padding: EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    color: Colors.blue.shade700,
                    textColor: Colors.white,
                    child:
                        Text('Manage my accounts', textAlign: TextAlign.center),
                    onPressed: () => Navigate.to(AccountScreen()),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}

class SummaryCardRow extends StatelessWidget {
  final Account account;
  const SummaryCardRow({
    Key key,
    @required this.account,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            account.name,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Text(
            "${account.balance} XAF",
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
