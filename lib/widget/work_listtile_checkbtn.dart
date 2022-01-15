import 'package:awesomethink/firebase/work_provider.dart';
import 'package:awesomethink/model/work.dart';
import 'package:awesomethink/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WorkListTileCheckBtn extends StatefulWidget {
  const WorkListTileCheckBtn({Key? key, required this.work, required this.workProvider}) : super(key: key);
  final Work work;
  final WorkProvider? workProvider;
  @override
  _WorkListTileCheckBtnState createState() => _WorkListTileCheckBtnState(work: work, workProvider: workProvider);
}

class _WorkListTileCheckBtnState extends State<WorkListTileCheckBtn> {

  final Work? work;
  final WorkProvider? workProvider;
  bool isVisible = true;

  _WorkListTileCheckBtnState({required this.work, required this.workProvider});


  void workingCheck () {
    //TODO 확인창 띄우고 확인하면 체크됨.
    //우선 바로 눌리게 해놈
    FirebaseFirestore.instance
        .collection("work")
        .doc(work?.workUid)
        .get()
        .then((val) {
      val.reference
          .update({"workingTimeState": WorkingTimeState.check.index});
    }).whenComplete(() {
      work!.workingTimeState!=WorkingTimeState.check;
      setState(() {
        workProvider!.setTodayWork(work);
        isVisible=false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if(!isVisible){
      return Container();
    }
    if (work!.workingTimeState== WorkingTimeState.wait.index&&work!.endTime!=null) {
      isVisible=true;
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