import 'package:flutter/material.dart';
import 'package:pushupapp/api/pojo.dart' as pojo;
import 'package:pushupapp/api/requests.dart';
import 'package:pushupapp/ui/widgets/index.dart' as widgets;
import 'package:pushupapp/api/httpexceptions.dart' as he;
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _displayingIndex;
  late List<pojo.Group> _groups;

  @override
  void initState() {
    super.initState();
    _groups = API.groups;
    _displayingIndex = _groups.length > 2 ? 1 : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Main homepage contents
      body: Column(
          // Column Alignment
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,

          // Main body of home page
          children: [
            // Centered Flip Coin widget
            widgets.CenterDisplay(
                groups: _groups,
                onPageUpdated: _onPageUpdated,
                index: _displayingIndex),

            // Pushup button widget
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: widgets.GlowingButton(
                    text: API.username == _groups[_displayingIndex].coinHolder
                        ? "Click to complete your pushups!"
                        : _groups[_displayingIndex].coinHolder +
                            " is the coin holder",
                    onPressed: _updateCoin)),

            // Group information widget
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: widgets.GroupInfo(_groups[_displayingIndex]),
            ),
          ]),
    );
  }

  void _onPageUpdated(int page) {
    setState(() {
      _displayingIndex = page;
    });
  }

  void _updateCoin() {
    pojo.Group _g = _groups[_displayingIndex];
    if (API.username != _g.coinHolder) {
      return;
    }
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: widgets.Pledge(
                  count: _g.coin,
                  onPressed: () {
                    Navigator.of(context).pop();
                  }));
        }).then((snap) {
      API
          .post()
          .coin(_g.id)
          .then((value) => API.get().groups().then((groups) => setState(() {
                _groups = API.groups;
              })))
          .catchError((error) {
        _errorHandle(error);
      });
    }).catchError((error) {
      _errorHandle(error);
    });
  }

  _errorHandle(he.HttpException e) {
    switch (e.status) {

      // Re-establish token
      case he.Status.unauthorized:
        _loginWithSavedPrefs();
        _updateCoin();
        break;

      case he.Status.ratelimit:
        widgets.errorDialog(context, "Slow down there");
        break;

      default:
        widgets.errorDialog(context, "An internal server error has occurred.");
        break;
    }
  }
}

Future<void> _loginWithSavedPrefs() async {
  SharedPreferences? pref = await SharedPreferences.getInstance();
  Object? username = pref.get("puapp_username");
  Object? password = pref.get("puapp_password");
  await API.initialize(username as String, password as String);
}
