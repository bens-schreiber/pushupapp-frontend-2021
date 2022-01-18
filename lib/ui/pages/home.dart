import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pushupapp/api/pojo.dart';
import 'package:pushupapp/api/requests.dart';
import 'package:pushupapp/ui/widgets/index.dart';

/// Main page with Center Display widget in the middle
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _displayingIndex = 0;

  @override
  Widget build(BuildContext context) {
    return API.builder((groups) => Scaffold(
        body: Column(
            // Column Alignment
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,

            // Main body of home page
            children: groups.isEmpty
                ? _joinGroup()
                : [
                    // Centered Flip Coin widget
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 35),
                          child: CenterDisplay(
                              groups: groups,
                              onPageUpdated: _onPageUpdated,
                              index: _displayingIndex),
                        ),
                        IndexIndicator(
                          size: groups.length,
                          index: _displayingIndex,
                        )
                      ]
                    ),

                    // Pushup button widget
                    Padding(
                        padding:
                            const EdgeInsets.only(top: 5, left: 10, right: 10),
                        child: GlowingButton(
                            text: API.username ==
                                    groups[_displayingIndex].coinHolder
                                ? "Click to complete your pushups!"
                                : groups[_displayingIndex].coinHolder +
                                    " is the coin holder",
                            onPressed: _updateCoin)),

                    // Group information widget
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: GroupInfo(groups[_displayingIndex]),
                    )
                  ])));
  }

  _joinGroup() {
    return [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Click the icon to join a group",
              style: TextStyle(color: Colors.grey[600], fontSize: 20)),
          Center(
            child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () async {
                  ClipboardData? cdata =
                      await Clipboard.getData(Clipboard.kTextPlain);
                  if (cdata == null ||
                      cdata.text == null ||
                      cdata.text!.isEmpty ||
                      cdata.text!.length != 36) {
                    return MDialog.okDialog(
                        context, "Copy an invite code to your clipboard.");
                  }
                  try {
                    await API.post().join(cdata.text!);
                    await API.get().groups();

                    MDialog.okDialog(context, "Group joined!");
                  } on HttpException {
                    MDialog.okDialog(
                        context, "Unknown or invalid invite code.");
                  } on Exception {
                    MDialog.noConnection(context);
                  }
                },
                icon: Icon(
                  Icons.add_box_outlined,
                  color: Colors.grey[600],
                  size: 30,
                )),
          ),
        ],
      )
    ];
  }

  void _onPageUpdated(int page) {
    setState(() {
      _displayingIndex = page;
    });
  }

  void _updateCoin() {
    Group _g = API.groups[_displayingIndex];
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
                    } on SocketException {
                      MDialog.noConnection(context);
                    } on HttpException {
                      MDialog.internalError(context);
                    }
                  }));
        });
  }
}
