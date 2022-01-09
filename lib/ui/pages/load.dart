import 'package:flutter/material.dart';

class LoadPage extends StatelessWidget {
  const LoadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: const Center(
                child: SizedBox(
                    height: 250,
                    width: 250,
                    child: FittedBox(child: Image(image: AssetImage("assets/logoback.png"))))),
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Colors.redAccent,
                  Colors.orange,
                  Colors.deepOrangeAccent
                ]))));
  }
}
