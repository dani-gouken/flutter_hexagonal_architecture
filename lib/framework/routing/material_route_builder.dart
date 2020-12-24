import 'package:flutter/material.dart';

import 'i_route_builder.dart';

class MaterialRouteBuilder extends IRouteBuilder {
  @override
  Object buildRoute(BuildContext context, Widget widget) {
    return MaterialPageRoute(builder: (context) => widget);
  }
}
