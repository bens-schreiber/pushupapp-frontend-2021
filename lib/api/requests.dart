import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:pushupapp/api/pojo.dart' as pojo;
import 'package:pushupapp/api/httpexceptions.dart' as he;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

Uri _parseUri(String i) => Uri.parse("https://puappapi.dev/api/" + i);

/// Interacts with the puappapi.dev API
/// Caches necessary values to send API requests
/// Caches main display information every request
class API {
  static late String token;
  static late String username;
  static List<pojo.Group> groups = List.empty(growable: true);

  /// Login a user and initialize proceeding requests
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

  /// Remove all cached values and stored values
  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("puapp_username");
    prefs.remove("puapp_password");
    token = "";
    username = "";
    groups = List.empty(growable: true);
  }

  /// Creates a new account through the API then calls
  /// The initialize() method with the new account information
  static Future<he.Status> newUser(String username, String password) async {
    try {
      // Create a new account
      await _Post._register(username, password);
      return he.Status.ok;
    } on Exception {
      rethrow;
    }
  }

  /// Return a POST object with HTTP POST requests
  static _Post post() => _Post();

  /// Return a DEL object with HTTP DEL requests
  static _Del del() => _Del();

  /// Return a GET object with HTTP GET requests
  static _Get get() => _Get();
}

/// POST methods
class _Post {

  // Used only in the API initialize method
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

  // Used only in the API newUser method
  static Future<void> _register(String username, String password) async {
    var res = await http
        .post(_parseUri("client/register"),
            headers: ({"Username": username, "Password": password}))
        .catchError((err) => throw err);

    if (res.statusCode != 201) {
      throw he.HttpException(res.statusCode);
    }
  }

  /// Create a group with the User as group leader
  Future<void> create() async {
    var res = await http
        .post(_parseUri("group/create"),
            headers: ({"Username": API.username, "Token": API.token}))
        .catchError((err) => throw err);

    if (res.statusCode != 200) {
      throw he.HttpException(res.statusCode);
    }
  }

  /// Join a group off the given ID
  Future<void> join(String id) async {
    var res = await http
        .post(_parseUri("group/join"),
            headers: ({"Username": API.username, "Token": API.token, "ID": id}))
        .catchError((err) => throw err);

    if (res.statusCode != 200) {
      throw he.HttpException(res.statusCode);
    }
  }

  /// Update the Pushup coin value by 1
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

/// DEL methods
class _Del {

  /// Remove the group and all members within it
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

  /// Remove a specific member of a group
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

/// GET methods
class _Get {

  // Used only for dev testing
  Future<void> healthCheck() async {
    var res = await http.get(_parseUri("healthcheck"),
        headers: {"Accept": "application/json"})
        .catchError((err) => throw err);

    if (res.statusCode != 200) {
      throw he.HttpException(res.statusCode);
    }
  }

  /// Grab the groups the user is in, along with relevant information
  /// for displaying those groups.
  /// Main request for the app.
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
