import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IndexIndicator extends StatefulWidget {
  final int index;
  const IndexIndicator({Key? key, required this.index}) : super(key: key);

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
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Icon(Icons.circle, size: 15, color: widget.index == 0 ? Colors.deepOrangeAccent : Colors.grey[800]),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Icon(Icons.circle, size: 15, color: widget.index == 1 ? Colors.deepOrangeAccent : Colors.grey[800]),
          ),
          Icon(Icons.circle, size: 15, color: widget.index == 2 ? Colors.deepOrangeAccent : Colors.grey[800]),
        ],
      ),
    );
  }
}
