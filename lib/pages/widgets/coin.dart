import 'dart:math' as math;

import 'package:flutter/material.dart';

class FlipCoin extends StatefulWidget {
  final Image frontImage = const Image(image: AssetImage("assets/logo.png"));
  final Image back = const Image(image: AssetImage("assets/logoback.png"));

  const FlipCoin({Key? key}) : super(key: key);

  @override
  _FlipCoinState createState() => _FlipCoinState();
}

class _FlipCoinState extends State<FlipCoin>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  bool isFront = true;
  double dragPosition = 0;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    controller.addListener(() {
      setState(() {
        dragPosition = animation.value;
        setImageSide();
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Stack front = Stack(
      alignment: const Alignment(0, 0),
      children: [
        widget.frontImage,
        const Text("1", style: TextStyle(fontSize: 100, color: Colors.white))
      ],
    );

    final angle = dragPosition / 180 * math.pi;
    final transform = Matrix4.identity()
      ..setEntry(3, 2, 0.001)
      ..rotateY(angle);

    return GestureDetector(
      onHorizontalDragUpdate: (details) => setState(() {
        dragPosition -= details.delta.dx;
        dragPosition %= 360;
        setImageSide();
      }),
      onHorizontalDragEnd: (details) {
        double end = isFront ? (dragPosition > 180 ? 360 : 0) : 180;
        animation = Tween<double>(
          begin: dragPosition,
          end: end,
        ).animate(controller);
        controller.forward(from: 0);
      },
      child: Transform(
          transform: transform,
          alignment: Alignment.center,
          child: isFront
              ? front
              : Transform(
                  transform: Matrix4.identity()..rotateY(math.pi),
                  alignment: Alignment.center,
                  child: widget.back)),
    );
  }

  void setImageSide() {
    if (dragPosition <= 90 || dragPosition >= 270) {
      isFront = true;
    } else {
      isFront = false;
    }
  }
}
