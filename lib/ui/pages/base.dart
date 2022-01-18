import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pushupapp/api/httpexceptions.dart';
import 'package:pushupapp/api/requests.dart';
import 'package:pushupapp/ui/pages/index.dart';
import 'package:pushupapp/ui/widgets/navbar/google_nav_bar.dart';

import '../dialog.dart';

/// App bar and bottom nav bar base with a center display
class BaseLayout extends StatefulWidget {
  BaseLayout({Key? key}) : super(key: key);

  final List<Widget> pages = [const HomePage(), const MyGroupPage()];

  @override
  _BaseLayoutState createState() => _BaseLayoutState();
}

class _BaseLayoutState extends State<BaseLayout> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = widget.pages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(),
        bottomNavigationBar: _bottomNavigationBar(),
        body: _pages[_selectedIndex]);
  }

  Container _bottomNavigationBar() {
    return Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
        ]),
        child: SizedBox(
            height: 50,
            child: SafeArea(
                child: GNav(
                    backgroundColor: Colors.grey[850]!,
                    gap: 8,
                    activeColor: Colors.white,
                    mainAxisAlignment: MainAxisAlignment.center,
                    iconSize: 26,
                    padding: const EdgeInsets.only(
                        top: 5, bottom: 5, left: 40, right: 40),
                    duration: const Duration(milliseconds: 400),
                    tabBackgroundColor: const Color.fromRGBO(128, 128, 128, .3),
                    color: Colors.grey[700],
                    tabs: const [
                      GButton(icon: Icons.home_outlined, text: 'Home'),
                      GButton(
                          icon: Icons.admin_panel_settings_outlined,
                          text: 'Groups')
                    ],
                    selectedIndex: _selectedIndex,
                    onTabChange: (index) {
                      API.get().groups().catchError((e) {});
                      setState(() {
                        _selectedIndex = index;
                      });
                    }))));
  }

  AppBar _appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.grey[850],
      toolbarHeight: 35,
      actions: [
        IconButton(
            padding: const EdgeInsets.only(left: 25),
            onPressed: () {
              MDialog.confirmationDialogWithTask(
                  context,
                  "Are you sure you want to sign out?",
                  () => API.logout(),
                  () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (c) => const LoginPage())));
            },
            icon: Icon(Icons.logout, color: Colors.grey[600])),
        IconButton(
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
              } on SocketException {
                MDialog.noConnection(context);
              } on HttpException {
                MDialog.okDialog(context, "Unknown or invalid invite code.");
              }
            },
            icon: Icon(Icons.add_box_outlined, color: Colors.grey[600])),
        const Spacer()
      ],
    );
  }
}
