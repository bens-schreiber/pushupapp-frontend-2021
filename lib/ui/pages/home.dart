import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pushupapp/api/pojo.dart';
import 'package:pushupapp/api/requests.dart';
import 'package:pushupapp/ui/widgets/index.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _displayingIndex;
  late List<Group> _groups;

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
            children: _groups.isEmpty
                ? _joinGroup()
                : [
                    // Centered Flip Coin widget
                    CenterDisplay(
                        groups: _groups,
                        onPageUpdated: _onPageUpdated,
                        index: _displayingIndex),

                    // Pushup button widget
                    Padding(
                        padding:
                            const EdgeInsets.only(top: 5, left: 10, right: 10),
                        child: GlowingButton(
                            text: API.username ==
                                    _groups[_displayingIndex].coinHolder
                                ? "Click to complete your pushups!"
                                : _groups[_displayingIndex].coinHolder +
                                    " is the coin holder",
                            onPressed: _updateCoin)),

                    // Group information widget
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: GroupInfo(_groups[_displayingIndex]),
                    )
                  ]));
  }

  List<Widget> _joinGroup() {
    return [Container()];
  }

  void _onPageUpdated(int page) {
    setState(() {
      _displayingIndex = page;
    });
  }

  void _updateCoin() {
    Group _g = _groups[_displayingIndex];
    if (API.username != _g.coinHolder) {
      return;
    }
    showDialog(
        context: context,
        builder: (c) {
          return AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: Pledge(
                  count: _g.coin,
                  onPressed: () async {
                    try {
                      Navigator.of(c).pop();
                      await API.post().coin(_g.id);
                      await API.get().groups();
                      setState(() {
                        _groups = API.groups;
                      });
                    } on SocketException {
                      MDialog.noConnection(context);
                    } on HttpException {
                      MDialog.internalError(context);
                    }
                  }));
        });
  }
}
