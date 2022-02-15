// ignore_for_file: must_be_immutable

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
                //중복등록 못하게 validation
                bool check = vacationValidation(dateTime!);
                //유효한 날짜인 경우
                if (check) {
                  vacationStart=dateTime;
                } else {
                  Get.snackbar("잘못된 날짜", "날짜를 다시 선택해주세요");
                  return;
                }
              }else{
                bool check = vacationValidation(dateTime!);
                if (check) {
                  vacationEnd=dateTime;
                } else {
                  Get.snackbar("잘못된 날짜", "날짜를 다시 선택해주세요");
                  return;
                }
              }
              if(vacationEnd==null) {
                showCalendar("end");
              }
              if(vacationEnd!=null&&vacationEnd!=null) {
                requestVacation();
              }
            }
          );
    }

  //TODO 휴무 시작일은 근무가 없는날 && 오늘부터 가능 (이전일 신청 불가) - Validation 추가
  bool vacationValidation(DateTime date){
    //이번주 근무기록이 비어있으면 true 리턴
    if((workController.weeklyWorkList as List<Work?>).isEmpty){
      return true;
    }
    int? year = date.year;
    int? month = date.month;
    int? day = date.day;
    bool result = true;
    for(Work? w in workController.weeklyWorkList){
      //중복이면 false 하고 반복 중단
      if(w?.startTime!.year==year&&w?.startTime!.month==month&&w?.startTime!.day==day){
        result = false;
        break;
        //아니면
      }else{
        result = true;
      }
    }
    return result;
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


