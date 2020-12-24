import 'package:flutter/material.dart';

abstract class IRouteBuilder {
  Object buildRoute(BuildContext context, Widget widget);
}
