import 'package:flutter/material.dart';

class GlowingButton extends StatefulWidget {
  static const Color color1 = Colors.deepOrangeAccent;
  static const Color color2 = Colors.orangeAccent;
  final String text;
  final Function onPressed;
  final double height;
  final double fontSize;
  const GlowingButton({Key? key, this.height = 48, this.fontSize = 20, required this.text, required this.onPressed}) : super(key: key);

  @override
  _GlowingButtonState createState() => _GlowingButtonState();
}

class _GlowingButtonState extends State<GlowingButton> {
  late String _text;
  var scale = 1.0;
  @override
  Widget build(BuildContext context) {

    // In order to properly refresh the widget on setState()
    // variables must be declared in build.
    _text = widget.text;

    return GestureDetector(
      onTapDown: (val) {
        widget.onPressed();   // Call passed in function
      },
      child: Container(
        height: widget.height,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            gradient: const LinearGradient(
              colors: [
                GlowingButton.color1,
                GlowingButton.color2,
              ],
            )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _text,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: widget.fontSize,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}