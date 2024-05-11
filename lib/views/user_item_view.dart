import 'package:flutter/material.dart';

import '../model/user_model.dart';

class UserItemView extends StatefulWidget{

  final User item;

  UserItemView({Key? key, required this.item}) : super(key: key);
  @override
  State<StatefulWidget> createState() {

    return UserItemViewState();
  }
  
}
class UserItemViewState extends State<UserItemView>{
  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.greenAccent,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Name: ", ),
              Text(widget.item.name),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Email: ", ),
              Text(widget.item.email),
            ],
          ),
        ],
      ),
    );
  }
  
}