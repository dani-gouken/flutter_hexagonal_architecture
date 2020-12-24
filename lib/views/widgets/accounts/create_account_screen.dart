import 'package:bot_toast/bot_toast.dart';
import 'package:flui/flui.dart';
import 'package:flutter/material.dart';
import 'package:hexa/core/application/services/validation_service.dart';
import 'package:hexa/core/domain/models/account.dart';
import 'package:hexa/framework/routing/navigate.dart';
import 'package:hexa/views/providers/account_provider.dart';
import 'package:hexa/views/screens/account_screen.dart';
import 'package:hexa/views/widgets/app_scaffold.dart';
import 'package:provider/provider.dart';

class CreateAccountScreen extends StatefulWidget {
  CreateAccountScreen({Key key}) : super(key: key);

  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Account account;
  @override
  void initState() {
    account = Account();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backButton: true,
      title: "Create an account",
      body: Consumer<AccountProvider>(
        builder: (context, provider, _) => Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration:
                      InputDecoration(labelText: "Enter the account name"),
                  onChanged: (v) => account.name = v,
                  validator: (v) => ValidationService.isEmpty(account.name)
                      ? "Please enter a name"
                      : null,
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration:
                      InputDecoration(labelText: "Enter the initial balance"),
                  onChanged: (v) => account.balance = double.parse(v),
                  validator: (v) =>
                      ValidationService.isInvalidAmount(account.balance)
                          ? "Please enter an amount"
                          : null,
                ),
                SizedBox(
                  height: 16,
                ),
                FLLoadingButton(
                    loading: provider.createdAccountsTask.isOngoing,
                    color: Colors.blue,
                    onPressed: () {
                      _onSavePressed(context);
                    },
                    child: Text(
                      "Save",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSavePressed(BuildContext context) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    await context.read<AccountProvider>().add(account);
    Navigate.to(AccountScreen(), replace: true);
    BotToast.showSimpleNotification(title: "Account created");
  }
}
