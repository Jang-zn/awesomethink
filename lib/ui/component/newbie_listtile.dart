import 'package:awesomethink/controller/user_controller.dart';
import 'package:awesomethink/data/model/member.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewbieListTile extends StatelessWidget {
  Member? newbie;
  NewbieListTile(this.newbie);
  final UserController userController = Get.find<UserController>();

  void newbieAuth() async {
    newbie?.state=true;
    await userController.updateUserInfo(newbie);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Container(
            margin:EdgeInsets.only(bottom:8),
            child:Row(
              children:[
                Text(newbie!.name!),
                SizedBox(width: 10, height: 10),
                Text(newbie!.position!),
                SizedBox(width: 120, height: 10),
                Container(
                  width:60,
                  height:20,
                  child: TextButton(
                    child: const Text("승인",
                        style:TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        )
                    ),
                    style: TextButton.styleFrom(
                      primary: Colors.black,
                      padding:EdgeInsets.zero,
                      backgroundColor: Colors.lightGreen
                    ),
                    onPressed: newbieAuth
                  )
                )
              ]
            )
          ),
          subtitle: Row(
            children: <Widget>[
              Text(newbie!.email!),
              SizedBox(width: 10, height: 10),
              Text(newbie!.phone!),
            ],
          ),
        ),
      ),
    );
  }
}