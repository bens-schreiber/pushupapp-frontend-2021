import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pushupapp/ui/pages/widgets/coin.dart' as widgets;
import 'package:pushupapp/api/pojos.dart' as pojo;

class CenterDisplay extends StatefulWidget {
  final List<pojo.Group> groups;
  static const int hi = 1;
  const CenterDisplay(this.groups, {Key? key}) : super(key: key);

  @override
  _CenterDisplayState createState() => _CenterDisplayState();
}

class _CenterDisplayState extends State<CenterDisplay> {
  late int _currentIndex;
  final List _coins = List.empty(growable: true);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Initialize values on coins
    for (pojo.Group group in widget.groups) {
      _coins.add(widgets.Coin(group.coin));
    }

    _currentIndex = _coins.length == 3 ? 1 : 0;
  }

  @override
  Widget build(BuildContext context) {
    if (_coins.length  == 1) { return _coins[_currentIndex]; }
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      // Back coin button
      IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.grey[600]),

          // Button is disabled if null by default. Disable button if
          // iterating through the list is impossible.
          onPressed: _currentIndex == 0 ? null :
              () {setState(() {_currentIndex--;});}
          ),

      _coins[_currentIndex], // Coin widget

      // Forward coin button
      IconButton(
          icon: Icon(Icons.arrow_forward_ios, color: Colors.grey[600]),

          // Button is disabled if null by default. Disable button if
          // iterating through the list is impossible.
          onPressed: _currentIndex == (_coins.length - 1) ? null :
          () {setState(() {_currentIndex++;});}
          ),
    ]);
  }
}
