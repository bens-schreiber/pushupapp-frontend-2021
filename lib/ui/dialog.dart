import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pushupapp/api/requests.dart';

abstract class MDialog {
  static const String _connectionError = "A connection error has occurred.";
  static const String _internalError = "An internal error has occurred";
  static const String _invalidCredentials = "Invalid username or password";
  static const String _noConnection = "No connection to the internet could be established.";
  static const String _rateLimited = "You are being ratelimited.";

  static void okDialog(BuildContext context, String message) {
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

  static void connectionError(context) {
    okDialog(context, _connectionError);
  }
  static void internalError(context) {
    okDialog(context, _internalError);
  }
  static void invalidCredentials(context) {
    okDialog(context, _invalidCredentials);
  }
  static void noConnection(context) {
    okDialog(context, _noConnection);
  }

  static void rateLimited(context) {
    okDialog(context, _rateLimited);
  }

  static void confirmationDialog(BuildContext context, String message, Function future,
      Function onPressed) {
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
                        API.get().groups().then((snap) {
                          onPressed();
                        }).catchError((e) => e);
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

  static void confirmationDialogNoRefresh(BuildContext context, String message,
      Function future, Function onPressed) {
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
                      future().then((value) => onPressed());
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
}