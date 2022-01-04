import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pushupapp/ui/pages/widgets/coin.dart' as widgets;

class CenterDisplay extends StatefulWidget {
  const CenterDisplay({Key? key}) : super(key: key);

  @override
  _CenterDisplayState createState() => _CenterDisplayState();
}

class _CenterDisplayState extends State<CenterDisplay> {
  int _currentIndex = 1;
  final List _coins = [widgets.Coin(1), widgets.Coin(2), widgets.Coin(3)];

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      // Back coin button
      IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.grey[600]),
          onPressed: () {
            if (_currentIndex != 0) {
              setState(() {
                _currentIndex--;
              });
            }
          }),

      _coins[_currentIndex], // Coin widget

      // Forward coin button
      IconButton(
          icon: Icon(Icons.arrow_forward_ios, color: Colors.grey[600]),
          onPressed: () {
            if (_currentIndex < (_coins.length - 1)) {
              setState(() {
                _currentIndex++;
              });
            }
          })
    ]);
  }
}
