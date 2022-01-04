import 'package:flutter/material.dart';

class PushupButton extends StatefulWidget {
  const PushupButton({Key? key}) : super(key: key);

  @override
  _PushupButtonState createState() => _PushupButtonState();
}

class _PushupButtonState extends State<PushupButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Make button take up maximum space

      child: DecoratedBox(
          decoration: const BoxDecoration(  //Gradient
              gradient: LinearGradient(colors: [Colors.deepOrange ,Colors.orange, Colors.orangeAccent, Colors.orange, Colors.deepOrange])),

          // Button itself
          child: ElevatedButton(
              onPressed: () {},
              child: const Text(
                  "Do Pushups",
                  style: TextStyle(
                      fontSize: 20, color: Colors.white, letterSpacing: 1
                  )
              ),

              style: ElevatedButton.styleFrom(
                primary: Colors.transparent,
                elevation: 0.0, // Remove shadow
              )
          )
      ),
    );
  }
}
