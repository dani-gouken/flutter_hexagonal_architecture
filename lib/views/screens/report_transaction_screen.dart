import 'package:bot_toast/bot_toast.dart';
import 'package:flui/flui.dart';
import 'package:flutter/material.dart';
import 'package:hexa/core/application/services/validation_service.dart';
import 'package:hexa/core/domain/models/account.dart';
import 'package:hexa/core/domain/models/transaction.dart';
import 'package:hexa/framework/routing/navigate.dart';
import 'package:hexa/views/providers/transaction_provider.dart';
import 'package:hexa/views/widgets/app_scaffold.dart';
import 'package:provider/provider.dart';

class ReportTransactionScreen extends StatefulWidget {
  ReportTransactionScreen(
      {Key key, @required this.type, @required this.account})
      : super(key: key);
  final TransactionType type;
  final Account account;
  @override
  _ReportTransactionScreenState createState() =>
      _ReportTransactionScreenState();
}

class _ReportTransactionScreenState extends State<ReportTransactionScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Transaction transaction;
  @override
  void initState() {
    transaction = new Transaction();
    transaction.type = widget.type;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backButton: true,
      title: "Report " +
          (widget.type == TransactionType.DEPOSIT ? "deposit" : "Withdrawal"),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Consumer<TransactionProvider>(
          builder: (context, transactionProvider, _) => Container(
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "${widget.account.name}: ",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${widget.account.balance} XAF",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: "Enter the amount of the transaction"),
                      onChanged: (v) => transaction.amount = double.parse(v),
                      validator: (v) =>
                          ValidationService.isInvalidAmount(transaction.amount)
                              ? "Please enter an amount"
                              : null,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: "Label of the transaction"),
                      onChanged: (v) => transaction.name = v,
                      validator: (v) =>
                          ValidationService.isEmpty(transaction.name)
                              ? "Please enter a label"
                              : null,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    FLLoadingButton(
                        loading:
                            transactionProvider.reportTransactionTask.isOngoing,
                        color: Colors.blue,
                        onPressed: () {
                          _onSavePressed(context, transactionProvider);
                        },
                        child: Text(
                          "Save",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ))
                  ],
                )),
          ),
        ),
      ),
    );
  }

  void _onSavePressed(BuildContext context, TransactionProvider provider) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    provider.report(transaction, widget.account).then((value) {
      BotToast.showSimpleNotification(title: "The transaction was created");
      Navigate.back(context);
    });
  }
}
