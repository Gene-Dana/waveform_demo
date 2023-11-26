import 'package:flutter/material.dart';

AppBar sharedAppBar(
  BuildContext context,
  String title,
) {
  return AppBar(
    backgroundColor: Color(0xff4BC0C8),
    title: Text(title),
  );
}
