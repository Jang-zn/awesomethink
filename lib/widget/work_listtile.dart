import 'package:awesomethink/firebase/work_provider.dart';
import 'package:awesomethink/model/work.dart';
import 'package:awesomethink/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkListTile extends StatefulWidget {
  late final DocumentSnapshot documentData;
  BuildContext context;

  WorkListTile(this.documentData, this.context);

  @override
  _WorkListTileState createState() => _WorkListTileState(documentData, context);
}

class _WorkListTileState extends State<WorkListTile> {
  WorkProvider? workProvider;
  late final DocumentSnapshot documentData;
  BuildContext context;
  late bool workEnd;

  _WorkListTileState(this.documentData, this.context) {
    workProvider= Provider.of<WorkProvider>(context);
  }


  void workingCheck() {
    //TODO 2. 확인창 띄우고 확인하면 체크됨.
    //우선 바로 눌리게 해놈
    if (workProvider!.getWorkEnd()!) {
      setState(() {});
      FirebaseFirestore.instance
          .collection("work")
          .doc(documentData.id)
          .get()
          .then((val) {
        val.reference
            .update({"workingTimeState": WorkingTimeState.check.index});
      });
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 1),
        content: Text(
          "퇴근후 가능합니다.",
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.black,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    Work work = Work.fromJson((documentData.data()) as Map<String, dynamic>);
    workEnd = workProvider!.getWorkEnd()!;

    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Stack(children: [
            ListTile(
              title: Container(
                  margin: EdgeInsets.only(bottom: 8),
                  child: Row(children: [
                    Text(work.createTimeToMMDDW()),
                    SizedBox(width: 10, height: 10),
                    Text(work.workingTimeCalc()),
                  ])),
              subtitle: Row(
                children: <Widget>[
                  Text(work.workingTimeToHHMM()),
                ],
              ),
            ),
            workEnd
                ? Container(
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
                        }))
                : Container(
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
                            backgroundColor: Colors.grey),
                        onPressed: (){}))
          ]),
        ));
  }
}
