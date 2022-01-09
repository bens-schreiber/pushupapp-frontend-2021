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
  var glowing = false;
  var scale = 1.0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (val) {
        setState(() {
          glowing = false;
        });
      },
      onTapDown: (val) {
        widget.onPressed();   // Call passed in function
        setState(() {
          glowing = true;
        });
      },
      child: AnimatedContainer(
        transform: Matrix4.identity()..scale(scale),
        duration: const Duration(milliseconds: 200),
        height: widget.height,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            gradient: const LinearGradient(
              colors: [
                GlowingButton.color1,
                GlowingButton.color2,
              ],
            ),
            boxShadow: glowing
                ? [
              BoxShadow(
                color: GlowingButton.color1.withOpacity(0.6),
                spreadRadius: 1,
                blurRadius: 16,
                offset: const Offset(-8, 0),
              ),
              BoxShadow(
                color: GlowingButton.color2.withOpacity(0.6),
                spreadRadius: 1,
                blurRadius: 16,
                offset: const Offset(8, 0),
              ),
              BoxShadow(
                color: GlowingButton.color1.withOpacity(0.2),
                spreadRadius: 16,
                blurRadius: 32,
                offset: const Offset(-8, 0),
              ),
              BoxShadow(
                color: GlowingButton.color2.withOpacity(0.2),
                spreadRadius: 16,
                blurRadius: 32,
                offset: const Offset(8, 0),
              )
            ]
                : []),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.text,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: widget.fontSize,
                  fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }
}