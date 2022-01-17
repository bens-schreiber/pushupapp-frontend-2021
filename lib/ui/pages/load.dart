import 'package:flutter/material.dart';

class LoadPage extends StatefulWidget {
  final Function(BuildContext)? toProcess;
  const LoadPage({Key? key, this.toProcess}) : super(key: key);

  /// Push a load screen to the view.
  /// On the completion of the toProcess async function, push page to the
  /// returned value.
  static void push(BuildContext context, Function(BuildContext context) toProcess) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => LoadPage(toProcess: toProcess)));
  }

  @override
  State<LoadPage> createState() => _LoadPageState();
}

class _LoadPageState extends State<LoadPage> {
  @override
  void initState() {
    super.initState();

    if (widget.toProcess != null) {
      Future.delayed(const Duration(milliseconds: 100)).then((_) => (widget.toProcess!(context) as Future<dynamic>).then((value) =>
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => value))
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: const Center(
                child: SizedBox(
                    height: 250,
                    width: 250,
                    child: FittedBox(
                        child:
                            Image(image: AssetImage("assets/logoback.png"))))),
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
