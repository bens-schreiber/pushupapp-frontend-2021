import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pushupapp/api/requests.dart';
import 'package:pushupapp/ui/errorhandle.dart' as handle;

void errorDialog(BuildContext context, String message) {
  showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
            title: const Text("iPushup"),
            content: Text(message),
            actions: [
              TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ]);
      });
}

void confirmationDialog(BuildContext context, String message, Function future, Function onPressed) {
  showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
            title: const Text("iPushup"),
            content: Text(message),
            actions: [
              TextButton(
                  child: const Text("Yes"),
                  onPressed: () {
                    future().then((snap) {
                      API.get().groups().then((snap) {onPressed();}).catchError((e) => handle.basicErrorHandle(e, context));
                    });
                    Navigator.of(context).pop();
                  }),
              TextButton(
                  child: const Text("No"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ]);
      });
}
