import 'package:awesomethink/firebase/firebase_provider.dart';
import 'package:awesomethink/firebase/user_database.dart';
import 'package:awesomethink/firebase/work_provider.dart';
import 'package:awesomethink/model/work.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


// TODO 휴무신청 하면 날짜 물어보고 날짜 받으면 된다?



class VacationBtn extends StatefulWidget {
  VacationBtn(
      {Key? key, required this.firebaseProvider, required this.buildContext})
      : super(key: key);
  final FirebaseProvider firebaseProvider;
  final BuildContext buildContext;



  @override
  _VacationBtnState createState() =>
      _VacationBtnState(
          firebaseProvider: firebaseProvider,
          buildContext : buildContext,
      );
}

class _VacationBtnState extends State<VacationBtn> {
  final FirebaseProvider firebaseProvider;
  final BuildContext buildContext;
  WorkProvider? workProvider;
  Work? currentWork;
  bool isAble = true;

  _VacationBtnState(
      {required this.firebaseProvider, required this.buildContext});


  @override
  void initState() {
    workProvider = Provider.of<WorkProvider>(buildContext);
  }


  void requestVacation() async {
    currentWork = Work().createWork(firebaseProvider.getUser()!.uid);
    //당일 중복등록 못하게 validation
    bool checkDuplication = await UserDatabase().checkDuplication(
        currentWork!.userUid!);

    //당일 첫 출근인경우
    if (checkDuplication) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      //work doc 생성
      firestore.collection("work").doc().set(currentWork!.toJson());
      //workUid 넣어줌
      //await 안쓰면 uid 날라간다.
      await firestore.collection("work")
          .where("userUid", isEqualTo: currentWork!.userUid)
          .where("workUid", isNull: true)
          .get().then(
              (value) {
            value.docs.forEach((doc) {
              currentWork!.workUid = doc.id;
              doc.reference.update({"workUid": doc.id});
            });
          }
      );
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
    FirebaseFirestore.instance.collection("work")
        .where("workUid", isEqualTo: currentWork!.workUid)
        .get()
        .then(
            (value) {
              value.docs.forEach(
                      (doc) {
                          doc.reference.update(currentWork!.toJson());
          });
        }
    ).whenComplete(
            () {
              workProvider!.setCurrentWork(currentWork);

            }
    );
  }


  @override
  Widget build(BuildContext context) {
    currentWork= workProvider!.getCurrentWork();
    //case 1. 출근기록 X --> currentWork==null
    if(currentWork?.workUid==null) {
      print("case1");
      return ElevatedButton(
        child: const Text("휴무신청"),
        onPressed: requestVacation,
        style: ElevatedButton.styleFrom(
          primary: Colors.blueAccent,
        ),
      );
    }

    //case 2. 출근기록 있음 / 근데 퇴근 안누름
    if(currentWork?.endTime==null){
      print("case2");
      return ElevatedButton(
          child: const Text("대기중"),
          onPressed: endTodayWorkingTime,
          style: ElevatedButton.styleFrom(
            primary: Colors.green,
          )
      );
    }else {
      //case 3. 출퇴근기록 있음 / 아직 출근버튼 안누름
      print("case3");
      return ElevatedButton(
        child: const Text("휴무신청"),
        onPressed: requestVacation,
        style: ElevatedButton.styleFrom(
          primary: Colors.blueAccent,
        ),
      );
    }

  }
}

