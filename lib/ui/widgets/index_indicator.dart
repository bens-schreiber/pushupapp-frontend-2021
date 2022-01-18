import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IndexIndicator extends StatefulWidget {
  final int index;
  final int size;
  const IndexIndicator({Key? key, required this.index, required this.size}) : super(key: key);

  @override
  _IndexIndicatorState createState() => _IndexIndicatorState();
}

class _IndexIndicatorState extends State<IndexIndicator> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.from(Iterable.generate(widget.size)).map((element) {
          return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Icon(Icons.circle, size: 15, color: widget.index == element ? Colors.deepOrangeAccent : Colors.grey[800]),
        );}).toList()
      ),
    );
  }
}
