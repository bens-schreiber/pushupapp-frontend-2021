import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pushupapp/api/requests.dart';
import 'package:pushupapp/api/pojo.dart' as pojo;
import 'package:pushupapp/ui/widgets/dialog.dart' as dialog;

class MyGroupPage extends StatefulWidget {
  const MyGroupPage({Key? key}) : super(key: key);

  @override
  _MyGroupPageState createState() => _MyGroupPageState();
}

class _MyGroupPageState extends State<MyGroupPage> {

  late List<pojo.Group> _groups;

  @override
  Widget build(BuildContext context) {
    _groups = API.groups;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 60.0, left: 25),
            child: Text("Create a Group", style: TextStyle(fontSize: 35, color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 25),
            child: Container(
              height: 100,
              width: 100,
              child: IconButton(padding: EdgeInsets.zero, icon: const Icon(Icons.add, size: 100, color: Colors.white),  onPressed: () {  }),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                gradient: const LinearGradient(
                colors: [
                Colors.deepOrangeAccent,
                Colors.orangeAccent
                ],
                )),
            ),
          )
        ],

      ),
    );
  }


  Widget displayMembers() {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 60.0, left: 25, bottom: 10),
            child: Text(
              "My Group",
              style: TextStyle(
                  fontSize: 35,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey[800]!,
                    borderRadius: BorderRadius.circular(5)),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: Column(
                      children: _groupWidgets(),
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  List<Widget> _groupWidgets() {
    List<Widget> _groupWidgets = List.empty(growable: true);
    pojo.Group group = _groups.where((g) => g.creator == API.username).first;
    _groupWidgets = group.members
        .where((member) => member != API.username)
        .map((member) => Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: Container(
          width: 400,
          height: 70,
          color: Colors.grey[700],
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                const Icon(Icons.account_circle_outlined,
                    size: 50, color: Colors.white),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(member,
                      style: const TextStyle(
                          fontSize: 27, color: Colors.white)),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15, right: 20),
                  child: IconButton(
                    icon: const Icon(Icons.block_rounded,
                        size: 50, color: Colors.red),
                    onPressed: () {
                      dialog.confirmationDialog(
                          context,
                          "Are you sure you'd like to kick " +
                              member +
                              "?",
                          API.del().kick(member), () {setState(() {
                        print("doin it");
                        _groups = API.groups;
                      });});
                    },
                  ),
                )
              ],
            ),
          )),
    ))
        .toList(growable: false);
    return _groupWidgets;
  }
}


