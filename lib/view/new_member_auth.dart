import 'package:awesomethink/firebase/user_database.dart';
import 'package:awesomethink/model/member.dart';
import 'package:awesomethink/widget/newbie_listtile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewMemberAuthPage extends StatefulWidget {
  const NewMemberAuthPage({Key? key}) : super(key: key);

  @override
  _NewMemberAuthPageState createState() => _NewMemberAuthPageState();
}

class _NewMemberAuthPageState extends State<NewMemberAuthPage> {
  late Stream<QuerySnapshot> newbieList = UserDatabase().getNewbieStream();

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
                child: StreamBuilder(
                  stream : newbieList,
                  //snapshot type 지정 안하면 docs 못꺼내옴
                  builder: (BuildContext context, AsyncSnapshot snapshot){
                    if(!snapshot.hasData){
                      return CircularProgressIndicator();
                    }
                    List<DocumentSnapshot> documentsList = snapshot.data!.docs;
                    return ListView(
                      children:
                        documentsList.map((eachDocument) => NewbieListTile(eachDocument)).toList(),
                    );

                  },
                )

                )));
  }
}