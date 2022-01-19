import 'package:awesomethink/data/model/work.dart';
import 'package:awesomethink/data/provider/auth_provider.dart';
import 'package:awesomethink/data/provider/user_provider.dart';
import 'package:awesomethink/data/provider/work_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkInOutBtn extends StatefulWidget {
  WorkInOutBtn(
      {Key? key, required this.firebaseProvider, required this.buildContext})
      : super(key: key);
  final FirebaseProvider firebaseProvider;
  final BuildContext buildContext;



  @override
  _WorkInOutBtnState createState() =>
      _WorkInOutBtnState(
          firebaseProvider: firebaseProvider,
          buildContext : buildContext,
      );
}

class _WorkInOutBtnState extends State<WorkInOutBtn> {
  final FirebaseProvider firebaseProvider;
  final BuildContext buildContext;
  WorkProvider? workProvider;
  Work? currentWork;

  _WorkInOutBtnState(
      {required this.firebaseProvider, required this.buildContext});


  @override
  void initState() {
    workProvider = Provider.of<WorkProvider>(buildContext);
  }


  void startTodayWorkingTime() async {
    currentWork = Work().createWork(firebaseProvider.getUser()!.uid);
    //당일 중복등록 못하게 validation
    bool checkDuplication = await UserProvider().checkDuplication(
        currentWork!.userUid!);

    //당일 첫 출근인경우
    if (checkDuplication) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      //work doc 생성
      firestore.collection("work").doc().set(currentWork!.toJson());
      workProvider!.setCurrentWork(currentWork);

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
    currentWork?.endTime = DateTime.now();
    UserProvider().firestore.collection("work")
        .where("startTime", isEqualTo: currentWork!.startTime)
        .get()
        .then(
            (value) {
              value.docs.forEach(
                      (doc) {
                          doc.reference.update(currentWork!.toJson());
                          workProvider!.setCurrentWork(currentWork);
          });
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    currentWork= workProvider!.getCurrentWork();
    //case 1. 출근기록 X --> currentWork==null
    if(currentWork?.startTime==null) {
      print("case1");
      return ElevatedButton(
        child: const Text("출근"),
        onPressed: startTodayWorkingTime,
        style: ElevatedButton.styleFrom(
          primary: Colors.blueAccent,
        ),
      );
    }

    //case 2. 출근기록 있음 / 근데 퇴근 안누름
    if(currentWork?.endTime==null){
      print("case2");
      return ElevatedButton(
          child: const Text("퇴근"),
          onPressed: endTodayWorkingTime,
          style: ElevatedButton.styleFrom(
            primary: Colors.green,
          )
      );
    }else {
      //case 3. 출퇴근기록 있음 / 아직 출근버튼 안누름
      print("case3");
      return ElevatedButton(
        child: const Text("출근"),
        onPressed: startTodayWorkingTime,
        style: ElevatedButton.styleFrom(
          primary: Colors.blueAccent,
        ),
      );
    }

  }
}

