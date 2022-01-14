import 'package:awesomethink/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WorkListTileCheckBtn extends StatefulWidget {
  const WorkListTileCheckBtn({Key? key, required this.documentData}) : super(key: key);
  final DocumentSnapshot documentData;
  @override
  _WorkListTileCheckBtnState createState() => _WorkListTileCheckBtnState(documentData: documentData);
}

class _WorkListTileCheckBtnState extends State<WorkListTileCheckBtn> {

  final DocumentSnapshot documentData;

  _WorkListTileCheckBtnState({required this.documentData});
  void workingCheck () {
    //TODO 확인창 띄우고 확인하면 체크됨.
    //우선 바로 눌리게 해놈
    FirebaseFirestore.instance
        .collection("work")
        .doc(documentData.id)
        .get()
        .then((val) {
      val.reference
          .update({"workingTimeState": WorkingTimeState.check.index});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (documentData["workingTimeState"] == WorkingTimeState.wait.index) {
      return Container(
          margin: EdgeInsets.only(top: 20, left: 250),
          width: 60,
          height: 30,
          child: TextButton(
              child: const Text("확정",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  )),
              style: TextButton.styleFrom(
                  primary: Colors.black,
                  padding: EdgeInsets.zero,
                  backgroundColor: Colors.lightGreen),
              onPressed: () {
                workingCheck();
              }));
    } else {
      return Container();

    }
  }
}
