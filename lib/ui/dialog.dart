import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pushupapp/api/requests.dart';

/// Provides popup alert notifications
abstract class MDialog {
  static const String _connectionError = "A connection error has occurred.";
  static const String _internalError = "An internal error has occurred";
  static const String _invalidCredentials = "Invalid username or password";
  static const String _noConnection = "No connection to the internet could be established.";
  static const String _rateLimited = "You are being ratelimited.";

  /// Basic dialog with a message and an "OK" button to dismiss
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

  /// Alert with a "Yes" or "No" option
  /// @param future and @param onPressed ran on the "Yes" option
  static void confirmationDialog(BuildContext context, String message,
      Function future) {
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
                      future().then((value) => Navigator.of(context).pop());
                    }),
                TextButton(
                    child: const Text("No"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ]);
        });
  }

  static void confirmationDialogWithTask(BuildContext context, String message,
      Function future, Function task) {
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
                      future().then((value) => task());
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
