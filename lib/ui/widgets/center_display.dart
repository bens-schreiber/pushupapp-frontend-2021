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

  final List<Widget> _coins = List.empty(growable: true);
  late PageController _pageController;

  @override
  void initState() {
    super.initState();

    // Initialize values on coins
    for (pojo.Group group in widget.groups) {
      _coins.add(FittedBox(child: widgets.Coin(group.coin)));
    }

    _pageController = PageController(
      initialPage: widget.index
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 270,
      width: 250,
      child: PageView(
        controller: _pageController,
        children: _coins,
        scrollDirection: Axis.vertical,
        onPageChanged: widget.onPageUpdated,

      ),
    );

  }
}
