import 'package:awesomethink/utils/time_format_converter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TestPage extends StatelessWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const TestWidget();
  }
}

class TestWidget extends StatefulWidget {
  const TestWidget({Key? key}) : super(key: key);

  @override
  _TestWidgetState createState() => _TestWidgetState();
}

void tempFunction(){

}

class _TestWidgetState extends State<TestWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:SafeArea(
            child:ListView(
              children: [
                Container(
                  width:MediaQuery.of(context).size.width*0.5,
                  child:ElevatedButton(onPressed: createData,
                      child: const Text("Create")),
                ),
                Container(
                  width:MediaQuery.of(context).size.width*0.5,
                  child:ElevatedButton(onPressed: readData,
                      child: const Text("Read")),
                ),
                Container(
                  width:MediaQuery.of(context).size.width*0.5,
                  child:ElevatedButton(onPressed: updateData,
                      child: const Text("Update")),
                ),
                Container(
                  width:MediaQuery.of(context).size.width*0.5,
                  child:ElevatedButton(onPressed: deleteData,
                      child: const Text("Delete")),
                ),
                Container(
                  child:Text(name,textAlign: TextAlign.center,)
                )
              ],
            )
        )
    );
  }



  String name = "테스트";

  void createData() {
  }
  void readData() {
  }
  void updateData() {
  }
  void deleteData() {
  }

  final DocumentReference dr = FirebaseFirestore.instance.doc("user/akh4517");

}
