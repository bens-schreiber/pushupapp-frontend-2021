import 'dart:math' as math;

import 'package:flutter/material.dart';

class Coin extends StatefulWidget {
  final int displayNum;
  bool isFront = true;
  double dragPosition = 0;

  Coin(this.displayNum, {Key? key}) : super(key: key);

  @override
  _CoinState createState() => _CoinState();
}

class _CoinState extends State<Coin> with SingleTickerProviderStateMixin {

  final Image _frontImage = const Image(image: AssetImage("assets/logo.png"));
  final Image _back = const Image(image: AssetImage("assets/logoback.png"));
  late int _displayNum;
  late bool _isFrontStart;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    _controller.addListener(() {
      setState(() {
        widget.dragPosition = _animation.value;
        setImageSide();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // In order to properly refresh the widget on setState()
    // variables must be declared in build.
    _displayNum = widget.displayNum;

    Stack front = Stack(
      alignment: Alignment.center,
      children: [
        _frontImage,
        Text(_displayNum.toString(), style: const TextStyle(fontSize: 100, color: Colors.white))
      ],
    );

    final angle = widget.dragPosition / 180 * math.pi;
    final transform = Matrix4.identity()
      ..setEntry(3, 2, 0.001)
      ..rotateY(angle);

    return GestureDetector(

      onHorizontalDragStart: (details) {
        _controller.stop();
        _isFrontStart = widget.isFront;
        
      },

      onHorizontalDragUpdate: (details) => setState(() {
        widget.dragPosition -= details.delta.dx;
        widget.dragPosition %= 360;
        setImageSide();
      }),
      onHorizontalDragEnd: (details) {

        var velocity = details.velocity.pixelsPerSecond.dx.abs();

        if (velocity >= 100) {
          widget.isFront = !_isFrontStart;
        }

        double end = widget.isFront ? (widget.dragPosition > 180 ? 360 : 0) : 180;
        _animation = Tween<double>(
          begin: widget.dragPosition,
          end: end,
        ).animate(_controller);
        _controller.forward(from: 0);
      },
      child: Transform(
          transform: transform,
          alignment: Alignment.center,
          child: widget.isFront
              ? front
              : Transform(
                  transform: Matrix4.identity()..rotateY(math.pi),
                  alignment: Alignment.center,
                  child: _back)),
    );
  }

  void setImageSide() {
    if (widget.dragPosition <= 90 || widget.dragPosition >= 270) {
      widget.isFront = true;
    } else {
      widget.isFront = false;
    }
  }
}
