import 'package:flutter/material.dart';
import 'package:pushupapp/api/pojo.dart' as pojos;

TextStyle _basic({double fontSize = 15}) => TextStyle(fontSize: fontSize, color: Colors.grey[600]);

class GroupInfo extends StatelessWidget {
  final pojos.Group group;
  const GroupInfo(this.group, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return Container(

      color: Colors.grey[850],  // Background color

      child: Padding(

        padding: const EdgeInsets.only(left: 5, right: 5),  // Box padding from sides of scaffold

        child: Padding(

          padding: const EdgeInsets.only(top: 15, bottom: 15),  // Padding adding onto the edges of the container

          child: Column(

              mainAxisAlignment: MainAxisAlignment.spaceAround,  // alignment
              children: [

                // first field
                Text(group.creator + "'s Group", style: _basic(fontSize: 17)),


                Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children:
                      group.members.map((user) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [Icon(Icons.account_circle_rounded, color: Colors.grey[600]), Text(user, style: _basic())],)
                      ).toList())
                ),

                Divider(color: Colors.grey[600], thickness: .65),

                Row(children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Icon(Icons.security_update_warning, color: Colors.grey[600]),
                  ),
                  Text("Current Coin Holder", style: _basic()),
                  const Spacer(),
                  Text(group.coinHolder, style: _basic())
                ]),

                Row(children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Icon(Icons.account_balance, color: Colors.grey[600]),
                  ),
                  Text("Total Group Pushups", style: _basic()),
                  const Spacer(),
                  Text("999", style: _basic())
                ]),

              ]),
        ),
      ),
    );
  }
}