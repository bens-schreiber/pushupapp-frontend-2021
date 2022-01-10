import 'dart:math' as math;

import 'package:flutter/material.dart';

class Coin extends StatefulWidget {
  final int displayNum;
  bool _isFront = true;
  double _dragPosition = 0;

  Coin(this.displayNum, {Key? key}) : super(key: key);

  @override
  _CoinState createState() => _CoinState();
}

class _CoinState extends State<Coin> with SingleTickerProviderStateMixin {

  final Image _frontImage = const Image(image: AssetImage("assets/logo.png"));
  final Image _back = const Image(image: AssetImage("assets/logoback.png"));
  late int _displayNum;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    _controller.addListener(() {
      setState(() {
        widget._dragPosition = _animation.value;
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

    final angle = widget._dragPosition / 180 * math.pi;
    final transform = Matrix4.identity()
      ..setEntry(3, 2, 0.001)
      ..rotateY(angle);

    return GestureDetector(
      onHorizontalDragUpdate: (details) => setState(() {
        widget._dragPosition -= details.delta.dx;
        widget._dragPosition %= 360;
        setImageSide();
      }),
      onHorizontalDragEnd: (details) {
        double end = widget._isFront ? (widget._dragPosition > 180 ? 360 : 0) : 180;
        _animation = Tween<double>(
          begin: widget._dragPosition,
          end: end,
        ).animate(_controller);
        _controller.forward(from: 0);
      },
      child: Transform(
          transform: transform,
          alignment: Alignment.center,
          child: widget._isFront
              ? front
              : Transform(
                  transform: Matrix4.identity()..rotateY(math.pi),
                  alignment: Alignment.center,
                  child: _back)),
    );
  }

  void setImageSide() {
    if (widget._dragPosition <= 90 || widget._dragPosition >= 270) {
      widget._isFront = true;
    } else {
      widget._isFront = false;
    }
  }
}
