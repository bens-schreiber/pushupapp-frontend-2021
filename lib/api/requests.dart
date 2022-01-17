import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:pushupapp/api/pojo.dart' as pojo;
import 'package:pushupapp/api/httpexceptions.dart' as he;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

Uri _parseUri(String i) => Uri.parse("https://puappapi.dev/api/" + i);

// Cached API variables
class API {
  static late String token;
  static late String username;
  static List<pojo.Group> groups = List.empty(growable: true);

  // Main constructor, return an instance of the API given a successful login
  static Future<he.Status> initialize(String username, String password) async {
    try {
      String token = await _Post._login(username, password);
      API.token = token;
      API.username = username;
      return he.Status.ok;
    } on Exception {
      rethrow;
    }
  }

  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("puapp_username");
    prefs.remove("puapp_password");
    token = "";
    username = "";
    groups = List.empty(growable: true);
  }

  // Secondary constructor, create an account then call main constructor
  static Future<he.Status> newUser(String username, String password) async {
    try {
      // Create a new account
      await _Post._register(username, password);
      return he.Status.ok;
    } on Exception {
      rethrow;
    }
  }

  static _Post post() => _Post();
  static _Del del() => _Del();
  static _Get get() => _Get();
}

// HTTP Post methods
class _Post {
  static Future<String> _login(String username, String password) async {
    var res = await http
        .post(_parseUri("client/login"),
            headers: ({"Username": username, "Password": password}))
        .catchError((err) => throw err);

    if (res.statusCode != 201) {
      throw he.HttpException(res.statusCode);
    }

    var body = json.decode(res.body);
    return body["token"];
  }

  static Future<void> _register(String username, String password) async {
    var res = await http
        .post(_parseUri("client/register"),
            headers: ({"Username": username, "Password": password}))
        .catchError((err) => throw err);

    if (res.statusCode != 201) {
      throw he.HttpException(res.statusCode);
    }
  }

  Future<void> create() async {
    var res = await http
        .post(_parseUri("group/create"),
            headers: ({"Username": API.username, "Token": API.token}))
        .catchError((err) => throw err);

    if (res.statusCode != 200) {
      throw he.HttpException(res.statusCode);
    }
  }

  Future<void> join(String id) async {
    var res = await http
        .post(_parseUri("group/join"),
            headers: ({"Username": API.username, "Token": API.token, "ID": id}))
        .catchError((err) => throw err);

    if (res.statusCode != 200) {
      throw he.HttpException(res.statusCode);
    }
  }

  Future<void> coin(String id) async {
    var res = await http
        .post(_parseUri("group/coin"),
            headers: ({"Username": API.username, "Token": API.token, "ID": id}))
        .catchError((err) => throw err);

    if (res.statusCode != 201) {
      throw he.HttpException(res.statusCode);
    }
  }
}

// HTTP Delete methods
class _Del {
  Future<void> disband() async {
    String id = API.groups
        .where((group) => group.creator == API.username)
        .first
        .id; // don't need to nullcheck

    var res = await http
        .delete(_parseUri("group/disband"),
            headers: ({"Username": API.username, "Token": API.token, "ID": id}))
        .catchError((err) => throw err);

    if (res.statusCode != 200) {
      throw he.HttpException(res.statusCode);
    }
  }

  Future<void> kick(String user) async {
    String id = API.groups
        .where((group) => API.username == group.creator)
        .first
        .id; // no need to nullcheck

    var res = await http
        .delete(_parseUri("group/kick/" + user),
            headers: ({"Username": API.username, "Token": API.token, "ID": id}))
        .catchError((err) => throw err);

    if (res.statusCode != 200) {
      throw he.HttpException(res.statusCode);
    }
  }
}

//HTTP GET methods
class _Get {
  Future<void> healthCheck() async {
    var res = await http.get(_parseUri("healthcheck"),
        headers: {"Accept": "application/json"})
        .catchError((err) => throw err);

    if (res.statusCode != 200) {
      throw he.HttpException(res.statusCode);
    }
  }

  Future<he.Status?> groups() async {
    var res = await http
        .get(_parseUri("group/" + API.username),
            headers: ({"Username": API.username, "Token": API.token}))
        .catchError((err) => throw err);

    if (res.statusCode != 200) {
      throw he.HttpException(res.statusCode);
    }

    API.groups = List<pojo.Group>.from(
        json.decode(res.body).map((x) => pojo.Group.fromJson(x)));

    return he.HttpException(res.statusCode).status;
  }
}
