import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Pledge extends StatefulWidget {
  final Function onPressed;
  final int count;
  const Pledge({Key? key, required this.onPressed, required this.count}) : super(key: key);

  @override
  _PledgeState createState() => _PledgeState();
}

class _PledgeState extends State<Pledge> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: 80,
      color: Colors.grey[850],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: SizedBox(
              height: 100,
              child: CupertinoScrollbar(
                isAlwaysShown: true,
                child: SingleChildScrollView(
                  // for Vertical scrolling
                  scrollDirection: Axis.vertical,
                  child: Text(
                    "iPushup Pledge: I hereby swear that I will effective immediately complete " + widget.count.toString() + " pushups, regardless of my current situation. In failure to complete pushups, I consent to having trained assassins pursue my immediate location and promptly dispose of me.",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 17.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: CheckboxListTile(
                title: const Text("I agree",
                    style: TextStyle(fontSize: 17, color: Colors.deepOrangeAccent)),
                value: _isChecked,
                onChanged: (newValue) {
                  setState(() {
                    _isChecked = newValue!;
                  });
                  // Wait for checkmark animation
                  Future.delayed(const Duration(milliseconds: 350)).then((_) {
                    widget.onPressed();
                  });
                },
                controlAffinity:
                    ListTileControlAffinity.leading //  <-- leading Checkbox
                ),
          )
        ],
      ),
    );
  }
}
