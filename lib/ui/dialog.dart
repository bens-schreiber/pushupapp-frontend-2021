import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Provides popup alert notifications
abstract class MDialog {
  static const String _connectionError = "A connection error has occurred.";
  static const String _internalError = "An internal error has occurred";
  static const String _invalidCredentials = "Invalid username or password";
  static const String _noConnection = "No connection to the internet could be established.";
  static const String _rateLimited = "You are being ratelimited.";

  /// Basic dialog with a message and an "OK" button to dismiss
  static Future<void> okDialog(BuildContext context, String message) async {
    await showDialog(
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

  static Future<void> connectionError(context) {
    return okDialog(context, _connectionError);
  }
  static Future<void> internalError(context) {
    return okDialog(context, _internalError);
  }
  static Future<void> invalidCredentials(context) {
    return okDialog(context, _invalidCredentials);
  }
  static Future<void> noConnection(context) {
    return okDialog(context, _noConnection);
  }

  static Future<void> rateLimited(context) {
    return okDialog(context, _rateLimited);
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
