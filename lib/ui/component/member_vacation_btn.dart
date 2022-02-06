import 'package:awesomethink/controller/user_controller.dart';
import 'package:awesomethink/controller/work_controller.dart';
import 'package:awesomethink/data/model/work.dart';
import 'package:awesomethink/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VacationBtn extends StatelessWidget {
  VacationBtn({Key? key, required this.context}) : super(key: key);
  BuildContext context;
  final UserController userController = Get.find<UserController>();
  late final WorkController workController = Get.find<WorkController>(tag:userController.userInfo.uid);
  bool vacationWait = false;
  DateTime? vacationStart;
  DateTime? vacationEnd;

  void showCalendar(String soe) {
   Future<DateTime?> selectedDate = showDatePicker(
       context: context,
       helpText: soe=="start"?"휴무 시작일 선택":"휴무 종료일 선택",
       initialDate: DateTime.now(),
       firstDate: DateTime(DateTime.now().year),
       lastDate: DateTime(DateTime.now().year+1),
       builder : (context, child){
         return DefaultTextStyle.merge(
             style:const TextStyle(fontSize: 20),
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
          userController.userInfo.uid, vacationStart!, vacationEnd!);
    }
    vacationList.sort((a,b)=>b.startTime!.compareTo(a.startTime!));


    vacationStart=null;
    vacationEnd=null;
    //work doc 생성 -> WorkingTimeState.vacationWait
    for(Work w in vacationList) {
      //주말(6:토 / 7:일) 제외하고 휴가등록
      if(w.startTime!.weekday<6) {
        workController.setWork(w);
      }
    }
  }

  void checkVacationState() {
    try {
      for (Work? w in workController.weeklyWorkList) {
        if(w!.workingTimeState==WorkingTimeState.vacationWait.index){
          vacationWait=true;
        }
      }
    }catch(e){
      vacationWait = false;
    }
  }


  @override
  Widget build(BuildContext context) {
    checkVacationState();
    if(!vacationWait) {
      return ElevatedButton(
        child: const Text("휴무신청"),
        onPressed: () {showCalendar("start");},
        style: ElevatedButton.styleFrom(
          primary: Colors.blueAccent,
        ),
      );
    }else{
      return ElevatedButton(
          child: const Text("승인대기"),
          onPressed: (){},
          style: ElevatedButton.styleFrom(
            primary: Colors.orange,
          )
      );
    }

  }
}


