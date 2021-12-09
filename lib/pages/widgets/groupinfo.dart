import 'package:flutter/material.dart';

final TextStyle _basic = TextStyle(fontSize: 13, color: Colors.grey[600]);

class GroupInfo extends StatefulWidget {
  const GroupInfo({Key? key}) : super(key: key);

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(

      color: Colors.grey[850],  // Background color

      child: Padding(

        padding: const EdgeInsets.only(left: 5, right: 5),  // Box padding from sides of scaffold

        child: Padding(

          padding: const EdgeInsets.only(top: 15, bottom: 15),  // Padding adding onto the edges of the container

          child: Column(

              mainAxisAlignment: MainAxisAlignment.spaceEvenly,  // alignment
              children: [

                // first field
                Text("Group Info", style: _basic),

                Divider(color: Colors.grey[600], thickness: .65),

                // second field
                Row(children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Icon(Icons.security_update_warning, color: Colors.grey[600]),
                  ),
                  Text("Current Coin Holder", style: _basic),
                  const Spacer(),
                  Text("tim", style: _basic)
                ]),

                // third field
                Row(children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Icon(Icons.manage_accounts_rounded, color: Colors.grey[600]),
                  ),
                  Text("Group Creator", style: _basic),
                  const Spacer(),
                  Text("tim", style: _basic)
                ]),

                Row(children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Icon(Icons.assignment_rounded, color: Colors.grey[600]),
                  ),
                  Text("Total Pushups", style: _basic),
                  const Spacer(),
                  Text("999", style: _basic)
                ])


              ]),
        ),
      ),
    );
  }
}
