import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pushupapp/ui/widgets/coin.dart' as widgets;
import 'package:pushupapp/api/pojo.dart' as pojo;

class CenterDisplay extends StatefulWidget {
  final List<pojo.Group> groups;
  final Function(int) onPageUpdated;
  final int index;
  const CenterDisplay({required this.groups, required this.onPageUpdated, required this.index, Key? key}) : super(key: key);

  @override
  _CenterDisplayState createState() => _CenterDisplayState();
}

class _CenterDisplayState extends State<CenterDisplay> {

  late List<Widget> _coins;
  late PageController _pageController;
  late List<pojo.Group> _groups;
  late int _index;

  @override
  Widget build(BuildContext context) {

    // In order to properly refresh the widget on setState()
    // changeable variables must be declared in build.
    _coins = List.empty(growable: true);
    _index = widget.index;
    _groups = widget.groups;

    // Initialize values on coins
    for (pojo.Group group in _groups) {
      _coins.add(FittedBox(child: widgets.Coin(group.coin)));
    }

    _pageController = PageController(
        initialPage: _index,
        viewportFraction: 0.9
    );

    return Column(
      children: [
        FittedBox(
          child: SizedBox(
            height: 415,
            width: 250,
            child: PageView(
              controller: _pageController,
              children: _coins,
              scrollDirection: Axis.vertical,
              onPageChanged: widget.onPageUpdated,
            ),
          ),
        ),
      ],
    );

  }
}
