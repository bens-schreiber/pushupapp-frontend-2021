import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void errorDialog(BuildContext context, String message) {
  showDialog(context: context, builder: (context) {
    return CupertinoAlertDialog(
        title: const Text("Pushup App"),
        content: Text(message),
        actions: [TextButton(child: const Text("OK"), onPressed: () {Navigator.of(context).pop();})]
    );
  });
}