import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:pushupapp/api/pojos.dart' as pojos;
import 'package:pushupapp/api/httpexceptions.dart' as he;
import 'dart:convert';

Uri _parseUri(String i) => Uri.parse("https://puappapi.dev/api/" + i);

// Cached API variables
class API {
  static List<pojos.Group> groups = List.empty();
  static String token = "";
  static String username = "";

  // Main constructor, return an instance of the API given a successful login
  static Future<void> initialize(String username, String password) async {
    try {
      String token = await _Post._login(username, password);
      API.token = token;
      API.username = username;
    } on Exception {
      rethrow;
    }
  }

  // Secondary constructor, create an account then call main constructor
  static Future<void> newUser(String username, String password) async {
    try {
      // Create a new account
      await _Post._register(username, password);

      // Login and return API
      initialize(username, password);
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
    var res = await http.post(_parseUri("client/login"),
        headers: ({"Username": username, "Password": password}));

    if (res.statusCode != 201) {
      throw he.HttpException(res.statusCode);
    }

    var body = json.decode(res.body);
    return body["token"];
  }

  static Future<void> _register(String username, String password) async {
    var res = await http.post(_parseUri("client/register"),
        headers: ({"Username": username, "Password": password}));

    if (res.statusCode != 201) {
      throw he.HttpException(res.statusCode);
    }
  }

  Future<void> create() async {
    var res = await http.post(_parseUri("group/create"),
        headers: ({"Username": API.username, "Token": API.token}));

    if (res.statusCode != 200) {
      throw he.HttpException(res.statusCode);
    }
  }

  Future<void> join(String id) async {
    var res = await http.post(_parseUri("group/join"),
        headers: ({"Username": API.username, "Token": API.token, "ID": id}));

    if (res.statusCode != 200) {
      throw he.HttpException(res.statusCode);
    }
  }

  Future<void> coin() async {
    // Option to update coin wont appear unless user is a coin holder, null check
    // is unnecessary.
    String id = "";

    // Find ID of group the user is creator of
    for (pojos.Group g in API.groups) {
      if (g.coinHolder == API.username) {
        id = g.id;
      }
    }

    var res = await http.post(_parseUri("group/coin"),
        headers: ({"Username": API.username, "Token": API.token, "ID": id}));

    if (res.statusCode != 201) {
      throw he.HttpException(res.statusCode);
    }
  }
}

// HTTP Delete methods
class _Del {
  Future<void> disband() async {
    // Option to disband wont appear unless user is a creator, null check
    // is unnecessary
    String id = "";

    // Find ID of group the user is creator of
    for (pojos.Group g in API.groups) {
      if (g.creator == API.username) {
        id = g.id;
      }
    }

    var res = await http.delete(_parseUri("group/disband"),
        headers: ({"Username": API.username, "Token": API.token, "ID": id}));

    if (res.statusCode != 200) {
      throw he.HttpException(res.statusCode);
    }
  }

  Future<void> kick(String user) async {
    // Option to disband wont appear unless user is a creator, null check
    // is unnecessary
    String id = "";

    // Find ID of group the user is creator of
    for (pojos.Group g in API.groups) {
      if (g.creator == API.username) {
        id = g.id;
      }
    }

    var res = await http.delete(_parseUri("group/kick/" + user),
        headers: ({"Username": API.username, "Token": API.token, "ID": id}));

    if (res.statusCode != 200) {
      throw he.HttpException(res.statusCode);
    }
  }
}

//HTTP GET methods
class _Get {
  Future<int> healthCheck() async {
    var res = await http
        .get(_parseUri("healthcheck"), headers: {"Accept": "application/json"});

    if (res.statusCode != 200) {
      throw he.HttpException(res.statusCode);
    }

    return res.statusCode;
  }

  Future<void> groups() async {
    var res = await http.get(_parseUri("group/" + API.username),
        headers: ({"Username": API.username, "Token": API.token}));

    if (res.statusCode != 200) {
      throw he.HttpException(res.statusCode);
    }

    // Cache resuls
    API.groups = List<pojos.Group>.from(
        json.decode(res.body).map((x) => pojos.Group.fromJson(x)));
  }
}
