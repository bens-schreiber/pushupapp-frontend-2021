import 'package:flutter/material.dart';
import 'package:pushupapp/api/requests.dart';
import 'package:pushupapp/ui/pages/index.dart' as pages;
import 'package:pushupapp/ui/widgets/navbar/google_nav_bar.dart' as gnav;

class BaseLayout extends StatefulWidget {
  const BaseLayout({Key? key}) : super(key: key);

  @override
  _BaseLayoutState createState() => _BaseLayoutState();
}

class _BaseLayoutState extends State<BaseLayout> {

  int _selectedIndex = 0;
  final List<Widget> _pages = [const pages.HomePage(), const pages.MyGroupPage(), Container()];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: _bottomNavigationBar(),
      body: _pages[_selectedIndex],
    );
  }

  Container _bottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black.withOpacity(.1),
          )
        ],
      ),
      child: SizedBox(
        height: 50,
        child: SafeArea(
          child: gnav.GNav(
            backgroundColor: Colors.grey[850]!,
            gap: 8,
            activeColor: Colors.white,
            mainAxisAlignment: MainAxisAlignment.center,
            iconSize: 26,
            padding: const EdgeInsets.only(top: 5, bottom: 5, left: 40, right: 40),
            duration: const Duration(milliseconds: 400),
            tabBackgroundColor: const Color.fromRGBO(128, 128, 128, .3),
            color: Colors.grey[700],
            tabs: [
              const gnav.GButton(
                icon: Icons.home_outlined,
                text: 'Home',
              ),
              const gnav.GButton(
                icon: Icons.admin_panel_settings_outlined,
                text: 'My Group',
              ),
              gnav.GButton(
                icon: Icons.account_circle_outlined,
                text: API.username,
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              API.get().groups();
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
