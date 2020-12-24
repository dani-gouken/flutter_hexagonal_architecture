import 'package:flui/flui.dart';
import 'package:flutter/material.dart';
import 'package:hexa/framework/routing/navigate.dart';
import 'package:hexa/views/widgets/add_drawer.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final bool backButton;
  final List<Widget> actions;
  final Widget body;
  const AppScaffold(
      {Key key,
      @required this.title,
      @required this.body,
      this.actions,
      this.backButton = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: actions ?? [],
        title: FLAppBarTitle(
          title: title,
          titleStyle: TextStyle(color: Colors.blue),
        ),
        centerTitle: true,
        leading: Builder(builder: (context) {
          if (backButton) {
            return IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.blue,
                ),
                onPressed: () {
                  Navigate.back(context);
                });
          }
          return IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.blue,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              });
        }),
      ),
      body: body,
    );
  }
}
