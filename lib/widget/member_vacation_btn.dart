import 'package:awesomethink/firebase/firebase_provider.dart';
import 'package:awesomethink/firebase/work_provider.dart';
import 'package:awesomethink/model/work.dart';
import 'package:awesomethink/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


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
  bool? vacationWait;
  DateTime? vacationStart;
  DateTime? vacationEnd;

  _VacationBtnState(
      {required this.firebaseProvider, required this.buildContext});


  @override
  void initState() {
    workProvider = Provider.of<WorkProvider>(buildContext);
  }



  void showCalendar(String soe) {
   Future<DateTime?> selectedDate = showDatePicker(
       context: context,
       helpText: soe=="start"?"휴무 시작일 선택":"휴무 종료일 선택",
       initialDate: DateTime.now(),
       firstDate: DateTime(DateTime.now().year),
       lastDate: DateTime(DateTime.now().year+1),
       builder : (context, child){
         return DefaultTextStyle.merge(
             style:TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
             child : Theme(
               data : ThemeData.dark(),
               child : Column(
               children:<Widget>[
                 SizedBox(
                   width: 400,
                   height: 500,
                   child: child,
                 )
               ]),
             )
          );
       },
   );
    selectedDate.then(
            (dateTime)  {
              if(soe=="start"){
                vacationStart=dateTime;
              }else{
                vacationEnd=dateTime;
              }
              if(dateTime!=null&&vacationEnd==null) {
                showCalendar("end");
              }
              if(vacationEnd!=null&&vacationEnd!=null) {
                requestVacation();
              }
            }
          );
    }


  void requestVacation() async {
    List<Work> vacationList=[];
    if(vacationStart!=null && vacationEnd!=null) {
      vacationList = Work().createVacation(
          firebaseProvider.getUser()!.uid, vacationStart!, vacationEnd!);
    }
    vacationList.sort((a,b)=>b.startTime!.compareTo(a.startTime!));


    vacationStart=null;
    vacationEnd=null;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    //work doc 생성 -> WorkingTimeState.vacationWait
    for(Work w in vacationList) {
      //주말(6:토 / 7:일) 제외하고 휴가등록
      if(w.startTime!.weekday<6) {
        firestore.collection("work").doc().set(w.toJson());
      }
    }
    //workUid 넣어줌
    //await 안쓰면 uid 날라간다.
    await firestore.collection("work")
           .where("userUid", isEqualTo: firebaseProvider.getUserInfo()!.uid)
           .where("workUid", isNull: true)
           .where("workingTimeState", isEqualTo: WorkingTimeState.vacationWait.index)
           .get().then(
               (value) {
             value.docs.forEach((doc) {
               doc.reference.update({"workUid": doc.id});
             });
             setState(() {
               vacationWait=true;
             });
           }
       );

  }

  void checkVacationState() async {
    await workProvider!.getCurrentVacation().then(
            (value) {
              vacationWait=value;
            }
    );
  }


  @override
  Widget build(BuildContext context) {
    checkVacationState();
    try {
      if (!vacationWait!) {
        print("no vacation");
        return ElevatedButton(
          child: const Text("휴무신청"),
          onPressed: () {
            showCalendar("start");
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.blueAccent,
          ),
        );
      } else {
        print("vacation wait");
        return ElevatedButton(
            child: const Text("승인대기"),
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              primary: Colors.orange,
            )
        );
      }
    }catch (e){
      return ElevatedButton(
        child: const Text("휴무신청"),
        onPressed: () {
          showCalendar("start");
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.grey,
        ),
      );
    }
  }
}


