import 'package:flutter/material.dart';
import 'package:pushupapp/api/pojo.dart' as pojos;
import 'package:pushupapp/api/requests.dart';

TextStyle _basic({double fontSize = 15}) =>
    TextStyle(fontSize: fontSize, color: Colors.grey[600]);

class GroupInfo extends StatelessWidget {
  final pojos.Group group;

  const GroupInfo(this.group, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[850], // Background color

      child: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5, top: 15, bottom: 15),
        // Box padding from sides of scaffold

        child: Column(mainAxisAlignment: MainAxisAlignment.center, // alignment
            children: [
              SizedBox(
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        group.creator == API.username
                            ? "My Group"
                            : group.creator + "'s Group",
                        style: _basic(fontSize: 17)),
                    IconButton(
                      icon: Icon(Icons.content_copy,
                          size: 20, color: Colors.grey[600]),
                      onPressed: () {},
                    ), //todo: copy id to clipboard, notify
                  ],
                ),
              ),
              Divider(color: Colors.grey[600], thickness: .65),
              SizedBox(
                height: 51,
                child: Column(
                  children: [
                    Expanded(
                      child:
                          ListView(shrinkWrap: true, children: _mainDisplay()),
                    ),
                  ],
                ),
              ),
            ]),
      ),
    );
  }

  List<Row> _mainDisplay() {
    return _chunk(group.members)
        .map((row) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row
                .map((user) => Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Row(children: [
                        Icon(Icons.account_circle_rounded,
                            color: Colors.grey[600]),
                        Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Text(user == API.username ? "You" : user,
                                style: TextStyle(
                                    fontSize: 17,
                                    color: group.coinHolder == user
                                        ? Colors.deepOrangeAccent
                                        : Colors.grey[600])))
                      ]),
                    ))
                .toList()))
        .toList();
  }

  List<List> _chunk(List list) {
    int chunkSize = 3;
    List<List> chunks = [];
    int len = list.length;
    for (var i = 0; i < len; i += chunkSize) {
      int size = i + chunkSize;
      chunks.add(list.sublist(i, size > len ? len : size));
    }
    return chunks;
  }
}
