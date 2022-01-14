import 'package:awesomethink/firebase/firebase_provider.dart';
import 'package:awesomethink/firebase/user_database.dart';
import 'package:awesomethink/firebase/work_provider.dart';
import 'package:awesomethink/model/work.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WorkInOutBtn extends StatefulWidget {
  const WorkInOutBtn(
      {Key? key, required this.firebaseProvider, required this.workProvider})
      : super(key: key);
  final FirebaseProvider firebaseProvider;
  final WorkProvider workProvider;

  @override
  _WorkInOutBtnState createState() =>
      _WorkInOutBtnState(
          firebaseProvider: firebaseProvider,
          workProvider: workProvider
      );
}

class _WorkInOutBtnState extends State<WorkInOutBtn> {
  final FirebaseProvider firebaseProvider;
  final WorkProvider workProvider;
  Work? todayWork;
  Work? recentWork;

  _WorkInOutBtnState(
      {required this.firebaseProvider, required this.workProvider});


  void startTodayWorkingTime() async {
    todayWork = Work().createWork(firebaseProvider.getUser()!.uid);
    //당일 중복등록 못하게 validation
    bool checkDuplication = await UserDatabase().checkDuplication(
        todayWork!.userUid!);

    //당일 첫 출근인경우
    if (checkDuplication) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      //work doc 생성
      firestore.collection("work").doc().set(todayWork!.toJson());
      //workUid 넣어줌
      //await 안쓰면 uid 날라간다.
      await firestore.collection("work")
          .where("userUid", isEqualTo: todayWork!.userUid)
          .where("workUid", isNull: true)
          .get().then(
              (value) {
            value.docs.forEach((doc) {
              todayWork!.workUid = doc.id;
              doc.reference.update({"workUid": doc.id});
            });
          }
      );
      workProvider.setTodayWork(todayWork);
      print("Tlqkf : "+todayWork.toString());
      //당일에 퇴근후 출근 또누른경우
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context)
          .showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 1),
            content: Text("당일 중복등록 불가",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.black,
          )
      );
    }
  }

  void endTodayWorkingTime() async {
    //recentWork 퇴근 안한경우 -> 퇴근 안누름
    if(recentWork!=null&&recentWork?.endTime==null){
      recentWork?.endTime = DateTime(recentWork!.startTime!.year,recentWork!.startTime!.month,recentWork!.startTime!.day,18,0);
      FirebaseFirestore.instance.collection("work")
          .where("workUid", isEqualTo: recentWork!.workUid)
          .get().then(
              (value) {
            value.docs.forEach((doc) {
              doc.reference.update(recentWork!.toJson());
            });
          }
      ).whenComplete(
              () {
            workProvider.setRecentWork(recentWork);
            todayWork=null;
          }
      );
      return;
    }

    //recentWork 퇴근 잘 한경우 -> todayWork로 처리
    todayWork?.endTime = DateTime.now();
    FirebaseFirestore.instance.collection("work")
        .where("userUid", isEqualTo: todayWork!.userUid)
        .where("endTime", isNull: true).get().then(
            (value) {
          value.docs.forEach((doc) {
            doc.reference.update(todayWork!.toJson());
          });
        }
    ).whenComplete(
            () {
              workProvider.setTodayWork(todayWork);
              todayWork=null;
            }
    );
  }


  @override
  void didChangeDependencies() {
    recentWork= workProvider.getRecentWork();
  }

  @override
  Widget build(BuildContext context) {

    todayWork=workProvider.getTodayWork();

    if ((recentWork!=null&&recentWork!.endTime!=null)||recentWork==null||todayWork?.workUid==null) {
      return ElevatedButton(
        child: const Text("출근"),
        onPressed: startTodayWorkingTime,
        style: ElevatedButton.styleFrom(
          primary: Colors.blueAccent,
        ),
      );
    } else {
      return ElevatedButton(
          child: const Text("퇴근"),
          onPressed: endTodayWorkingTime,
          style: ElevatedButton.styleFrom(
            primary: Colors.green,
          )
      );
    }
  }
}
