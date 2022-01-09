import 'package:awesomethink/firebase/firebase_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

late SignUpPageState pageState;

class SignUpPage extends StatefulWidget {
  @override
  SignUpPageState createState() {
    pageState = SignUpPageState();
    return pageState;
  }
}

class SignUpPageState extends State<SignUpPage> {

  TextEditingController pwController = TextEditingController();
  TextEditingController pwCheckController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController rankController = TextEditingController();
  TextEditingController emailController1 = TextEditingController();
  TextEditingController emailController2 = TextEditingController();
  TextEditingController phoneController1 = TextEditingController();
  TextEditingController phoneController2 = TextEditingController();
  TextEditingController phoneController3 = TextEditingController();

  void submit(){
    Navigator.of(context).pop();
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late FirebaseProvider fp;

  @override
  void didChangeDependencies() {
    fp= Provider.of<FirebaseProvider>(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
            child: ListView(
                children: [
                Container(
                    margin: EdgeInsets.symmetric(vertical: 50),
                    child: Column(children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 15, horizontal:70),
                        child:
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 90,
                                child: TextField(
                                  controller: emailController1,
                                  decoration: const InputDecoration(
                                      hintText: "000",
                                      hintStyle: TextStyle(color:Color.fromRGBO(180, 180, 180, 100),
                                      )
                                  ),
                                ),
                              ),
                              Container(
                                child: Text("@"),
                                margin: EdgeInsets.symmetric(horizontal: 10),
                              ),
                              Container(
                                width: 90,
                                child: TextField(
                                  controller: emailController2,
                                  decoration: const InputDecoration(
                                      hintText: "000",
                                      hintStyle: TextStyle(color:Color.fromRGBO(180, 180, 180, 100))
                                  ),
                                ),
                              ),
                            ]),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                        child: TextField(
                          obscureText: true,
                          controller: pwController,
                          decoration: const InputDecoration(
                            hintText: "Password",
                              hintStyle: TextStyle(color:Color.fromRGBO(180, 180, 180, 100))
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                        child: TextField(
                          obscureText: true,
                          controller: pwCheckController,
                          decoration: const InputDecoration(
                            hintText: "Password Check",
                              hintStyle: TextStyle(color:Color.fromRGBO(180, 180, 180, 100))
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                        child: TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            hintText: "Name",
                              hintStyle: TextStyle(color:Color.fromRGBO(180, 180, 180, 100))
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                        child: TextField(
                          controller: rankController,
                          decoration: const InputDecoration(
                            hintText: "Position",
                              hintStyle: TextStyle(color:Color.fromRGBO(180, 180, 180, 100))
                          ),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 15, left:70, right:70, bottom:40),
                          child:
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Container(
                                width: 40,
                                child: TextField(
                                  controller: phoneController1,
                                  decoration: const InputDecoration(
                                    hintText: "000",
                                      hintStyle: TextStyle(color:Color.fromRGBO(180, 180, 180, 100))
                                  ),
                                ),
                              ),
                              Container(
                                child: Text("-"),
                                margin: EdgeInsets.symmetric(horizontal: 10),
                              ),
                              Container(
                                width: 40,
                                child: TextField(
                                  controller: phoneController2,
                                  decoration: const InputDecoration(
                                    hintText: "0000",
                                      hintStyle: TextStyle(color:Color.fromRGBO(180, 180, 180, 100))
                                  ),
                                ),
                              ),
                              Container(
                                child: Text("-"),
                                margin: EdgeInsets.symmetric(horizontal: 10),
                              ),
                              Container(
                                width: 40,
                                child: TextField(
                                  controller: phoneController3,
                                  decoration: const InputDecoration(
                                    hintText: "0000",
                                    hintStyle: TextStyle(color:Color.fromRGBO(180, 180, 180, 100))
                                  ),
                                ),
                              ),
                            ])
                         ),
                      Container(
                        width:MediaQuery.of(context).size.width*0.5,
                        child:ElevatedButton(
                          child:Text("Submit"),
                          onPressed: submit,
                        )
                      )
                    ]))
    ])));
  }
}
