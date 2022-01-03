import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:pushupapp/api/pojos.dart' as pojos;
import 'package:pushupapp/api/httpexceptions.dart' as he;
import 'dart:convert';

Uri _parseUri(String i) {
  return Uri.parse("https://puappapi.dev/api/" + i);
}

class API {
  List<pojos.Group> groups;
  String token;
  String username;

  // Main constructor, return an instance of the API given a successful login
  //todo: groups
  static Future<API> initialize(String username, String password) async {
    try {
      String token = await Post._login(username, password);
      return API._(List.empty(), token, username);
    } on Exception { rethrow; }
  }

  // Private constructor
  API._(this.groups, this.token, this.username);

  post() => Post(this);
  del() => Del(this);
  get() => Get(this);
}

class Post {

  final API api;
  Post(this.api);
  
  static Future<String> _login(String username, String password) async {
    var res = await http.post(_parseUri("client/login"),
        headers: ({
          "Username": username,
          "Password": password
        }));

    if (res.statusCode != 201) {
      throw he.HttpException(res.statusCode);
    }

    var body = json.decode(res.body);
    return body["token"];
  }

  static Future<String> register(String username, String password) async {
    var res = await http.post(_parseUri("client/register"),
        headers: ({
          "Username": username,
          "Password": password
        }));

    if (res.statusCode != 201) {
      throw he.HttpException(res.statusCode);
    }

    var body = json.decode(res.body);
    return body["token"];
  }

  
}

class Del {
  final API api;
  Del(this.api);
}

class Get {
  final API api;
  Get(this.api);

  Future<int> healthCheck() async {
    var res = await http
        .get(_parseUri("healthcheck"), headers: {"Accept" : "application/json"});
    return res.statusCode;
  }
  
  void groups() async {
    var res = await http.get(_parseUri("group/" +  api.username),
        headers: ({
          "Username" : api.username,
          "Token": api.token
    }));

    // lol what the fuck
    api.groups = List<pojos.Group>.from(json.decode(res.body).map((x) => pojos.Group.fromJson(x)));
  }
}
