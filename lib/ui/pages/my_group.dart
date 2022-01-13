import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pushupapp/api/requests.dart';
import 'package:pushupapp/api/pojo.dart' as pojo;
import 'package:pushupapp/ui/widgets/dialog.dart' as dialog;
import 'package:flutter/services.dart';

class MyGroupPage extends StatefulWidget {
  const MyGroupPage({Key? key}) : super(key: key);

  @override
  _MyGroupPageState createState() => _MyGroupPageState();
}

class _MyGroupPageState extends State<MyGroupPage> {
  late List<pojo.Group> _groups;

  @override
  void initState() {
    super.initState();
    _groups = API.groups;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> child =
        _groups.where((group) => API.username == group.creator).isNotEmpty
            ? _displayGroup()
            : displayCreate();

    return Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: child));
  }

  List<Widget> displayCreate() {
    return [
      const Padding(
          padding: EdgeInsets.only(top: 60.0, left: 25),
          child: Text("Create a Group",
              style: TextStyle(
                  fontSize: 35,
                  color: Colors.white,
                  fontWeight: FontWeight.bold))),
      Padding(
          padding: const EdgeInsets.only(top: 15, left: 25),
          child: Container(
              height: 100,
              width: 100,
              child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.add, size: 100, color: Colors.white),
                  onPressed: () => dialog.confirmationDialog(
                          context,
                          "Are you sure you'd like to create a group?",
                          () => API.post().create(), () {
                        setState(() {
                          _groups = API.groups;
                        });
                      })),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  gradient: const LinearGradient(
                      colors: [Colors.deepOrangeAccent, Colors.orangeAccent]))))
    ];
  }

  List<Widget> _displayGroup() {
    return [
      const Padding(
          padding: EdgeInsets.only(top: 60.0, left: 25, bottom: 10),
          child: Text("My Group",
              style: TextStyle(
                  fontSize: 35,
                  color: Colors.white,
                  fontWeight: FontWeight.bold))),
      Padding(
          padding:
              const EdgeInsets.only(bottom: 25, left: 25, right: 25),
          child: _creatorButtons()),
      Padding(
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[800]!,
                  borderRadius: BorderRadius.circular(5)),
              child: SingleChildScrollView(
                  child: Column(
                    children: _groupWidgets(),
                  )))),
    ];
  }

  Widget _creatorButtons() {
    return Container(
        width: 400,
        height: 70,
        decoration: BoxDecoration(
            color: Colors.grey[800]!, borderRadius: BorderRadius.circular(5)),
        child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(children: [
              const Icon(Icons.group, size: 50, color: Colors.white,),
              const Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Text("My Group",
                      style: TextStyle(fontSize: 27, color: Colors.white))),
              const Spacer(),
              IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.content_copy,
                      size: 45, color: Colors.white),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(
                            text: _groups
                                .where((group) => API.username == group.creator)
                                .first
                                .id))
                        .then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          duration: Duration(milliseconds: 500),
                          content: Text("Group code copied.")));
                    });
                  }),
              Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.block_rounded,
                          size: 50, color: Colors.red),
                      onPressed: () {
                        dialog.confirmationDialog(
                            context,
                            "Are you sure you'd like to disband the group?",
                            () => API.del().disband(), () {
                          setState(() {
                            _groups = API.groups;
                          });
                        });
                      }))
            ])));
  }

  List<Widget> _groupWidgets() {
    List<Widget> _groupWidgets = List.empty(growable: true);
    pojo.Group group = _groups.where((g) => g.creator == API.username).first;
    _groupWidgets = group.members
        .where((member) => member != API.username)
        .map((member) => Padding(
            padding: const EdgeInsets.only(left: 10, right: 20),
            child: Container(
                width: 400,
                height: 70,
                decoration: BoxDecoration(
                    color: Colors.grey[800]!,
                    borderRadius: BorderRadius.circular(5)),
                child: Row(children: [
                  const Icon(Icons.account_circle_outlined,
                      size: 50, color: Colors.white),
                  Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(member,
                          style: const TextStyle(
                              fontSize: 27, color: Colors.white))),
                  const Spacer(),
                  Padding(
                      padding: const EdgeInsets.only(bottom: 15, right: 5),
                      child: IconButton(
                          icon: const Icon(Icons.block_rounded,
                              size: 50, color: Colors.red),
                          onPressed: () {
                            dialog.confirmationDialog(
                                context,
                                "Are you sure you'd like to kick " +
                                    member +
                                    "?",
                                () => API.del().kick(member), () {
                              setState(() {
                                _groups = API.groups;
                              });
                            });
                          }))
                ]))))
        .toList(growable: false);
    return _groupWidgets;
  }
}
