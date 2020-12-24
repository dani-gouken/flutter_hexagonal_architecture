import 'package:flui/flui.dart';
import 'package:flutter/material.dart';
import 'package:hexa/core/domain/models/transaction.dart';
import 'package:hexa/views/providers/transaction_provider.dart';
import 'package:hexa/views/widgets/app_scaffold.dart';
import 'package:hexa/views/widgets/home/summary_card.dart';
import 'package:provider/provider.dart';
import 'package:weather_icons/weather_icons.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        title: "Dashboard",
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SummaryCard(),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Transactions history",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "See all",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue.shade800,
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: Colors.blue.shade800,
                            )
                          ],
                        )
                      ],
                    ),
                    Expanded(child: LatestTransactionList())
                  ],
                ),
              ),
            )
          ],
        ));
  }
}

class LatestTransactionList extends StatelessWidget {
  const LatestTransactionList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
        builder: (context, transactionProvider, _) {
      if (transactionProvider.loadLatestTransactionTask.isOngoing) {
        return Center(child: CircularProgressIndicator());
      }
      if (transactionProvider.loadLatestTransactionTask.hasFailed) {
        return Text(
            transactionProvider.loadLatestTransactionTask.error.toString());
      }
      List<Transaction> transactions = transactionProvider.lastestTransactions;
      if (transactions.isEmpty) {
        return Center(child: Text("You currently have not transaction"));
      }
      return ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, i) {
            return FLListTile(
              title: Text(transactions[i].name),
              leading: Icon(
                transactions[i].isWithdrawal
                    ? WeatherIcons.direction_up_left
                    : WeatherIcons.direction_down_left,
                size: 32,
                color: transactions[i].isWithdrawal ? Colors.red : Colors.green,
              ),
              trailing: Text(
                "${transactions[i].isWithdrawal ? "-" : "+"} ${transactions[i].amount} XAF",
                style: TextStyle(
                    color: transactions[i].isWithdrawal
                        ? Colors.red
                        : Colors.green,
                    fontWeight: FontWeight.bold),
              ),
            );
          });
    });
  }
}
