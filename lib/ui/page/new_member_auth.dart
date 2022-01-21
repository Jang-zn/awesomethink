import 'package:awesomethink/controller/user_controller.dart';
import 'package:awesomethink/data/model/member.dart';
import 'package:awesomethink/data/provider/user_provider.dart';
import 'package:awesomethink/ui/component/newbie_listtile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewMemberAuthPage extends StatefulWidget {
  const NewMemberAuthPage({Key? key}) : super(key: key);

  @override
  _NewMemberAuthPageState createState() => _NewMemberAuthPageState();
}

class _NewMemberAuthPageState extends State<NewMemberAuthPage> {
  late List<Member?> newbieList;
  late final UserController userController;

  @override
  void initState() {
    userController = Get.find<UserController>();
    newbieList = userController.newbieList;
  }

  void backPage() {
    Get.back();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: backPage,
          ),
        ),
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                child:ListView.builder(
                    itemCount: newbieList.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index){
                      return NewbieListTile(newbieList[index]);
                    }
                )
            )));
  }
}
