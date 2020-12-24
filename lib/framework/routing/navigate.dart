import 'package:flutter/material.dart';
import 'package:hexa/framework/routing/i_route_builder.dart';

class Navigate {
  static GlobalKey<NavigatorState> _navigatorKey;
  static IRouteBuilder _routeBuilder;
  static GlobalKey<NavigatorState> get navigatorKey {
    if (_navigatorKey == null) {
      _navigatorKey = GlobalKey<NavigatorState>();
    }
    return _navigatorKey;
  }

  static void setRouteBuilder(IRouteBuilder routeBuilder) {
    _routeBuilder = routeBuilder;
  }

  static void to(Widget widget,
      {BuildContext context,
      bool replace = false,
      replaceAllExceptFirst = false,
      replaceAll = false,
      NavigatorState state,
      GlobalKey<NavigatorState> key}) {
    if (context != null) {
      state = Navigator.of(context);
    } else {
      state = _navigatorKey.currentState;
    }
    if (replaceAllExceptFirst) {
      state.pushAndRemoveUntil(
          _routeBuilder.buildRoute(context, widget), (route) => route.isFirst);
      return;
    }

    if (replaceAll) {
      state.pushAndRemoveUntil(
          _routeBuilder.buildRoute(context, widget), (route) => false);
      return;
    }

    if (replace) {
      state.pushReplacement(_routeBuilder.buildRoute(context, widget));
      return;
    }
    state.push(_routeBuilder.buildRoute(context, widget));
  }

  static back(BuildContext context) {
    Navigator.of(context).pop();
  }
}
