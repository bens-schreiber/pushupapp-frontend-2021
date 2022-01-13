import 'package:flutter/material.dart';
import 'package:pushupapp/api/requests.dart';
import 'package:pushupapp/api/httpexceptions.dart' as he;
import 'package:pushupapp/ui/widgets/dialog.dart' as dialog;
import 'package:shared_preferences/shared_preferences.dart';

basicErrorHandle(he.HttpException e, BuildContext context) {
  switch (e.status) {

  // Re-establish token
    case he.Status.unauthorized:
      _loginWithSavedPrefs();
      break;

    case he.Status.ratelimit:
      dialog.errorDialog(context, "Slow down there");
      break;

    default:
      dialog.errorDialog(context, "An internal server error has occurred.");
      break;
  }
}

Future<void> _loginWithSavedPrefs() async {
  SharedPreferences? pref = await SharedPreferences.getInstance();
  Object? username = pref.get("puapp_username");
  Object? password = pref.get("puapp_password");
  await API.initialize(username as String, password as String);
  await API.get().groups();
}