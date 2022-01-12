import 'package:awesomethink/firebase/user_database.dart';
import 'package:awesomethink/model/member.dart';
import 'package:flutter/material.dart';

class NewMemberAuthPage extends StatefulWidget {
  const NewMemberAuthPage({Key? key}) : super(key: key);

  @override
  _NewMemberAuthPageState createState() => _NewMemberAuthPageState();
}

class _NewMemberAuthPageState extends State<NewMemberAuthPage> {
  late List<Member> newbieList = UserDatabase().getNewbie();

  void backPage() {
    Navigator.of(context).pop();
  }

  void click(){
    print(newbieList.toString());
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
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
                child: ListView(
                  children: [
                      TextButton(
                        child:Text("click"),
                        onPressed: click
                      )
                  ],
                ))));
  }
}
