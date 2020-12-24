import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:hexa/container.dart';
import 'package:hexa/core/application/api/repositories/api_account_repository.dart';
import 'package:hexa/core/application/repositories/cache_account_repository.dart';
import 'package:hexa/core/application/repositories/cache_transaction_repository.dart';
import 'package:hexa/core/domain/repositories/account_repository.dart';
import 'package:hexa/core/domain/repositories/transaction_repository.dart';
import 'package:hexa/framework/persistence/i_persister.dart';
import 'package:hexa/framework/persistence/prefs_persister.dart';
import 'package:hexa/framework/routing/material_route_builder.dart';
import 'package:hexa/framework/routing/navigate.dart';
import 'package:hexa/views/providers/account_provider.dart';
import 'package:hexa/views/providers/transaction_provider.dart';
import 'package:hexa/views/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  Navigate.setRouteBuilder(MaterialRouteBuilder());
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  AppContainer.instance
      .set<IPersister>(new PrefsPersister(prefs))
      .set<TransactionRepository>(CacheTransactionRepository())
      .set<AccountRepository>(new ApiAccountRepository());
  runApp(HexApp());
}

class HexApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AccountProvider>(
            create: (context) => AccountProvider()),
        ChangeNotifierProxyProvider<AccountProvider, TransactionProvider>(
          create: (context) => TransactionProvider(),
          update: (context, value, previous) => previous.update(value),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: Navigate.navigatorKey,
        title: 'HexApp',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        builder: BotToastInit(), //1. call BotToastInit
        navigatorObservers: [
          BotToastNavigatorObserver()
        ], //2. registered route observer

        home: HomeScreen(),
      ),
    );
  }
}
