import 'package:awesomethink/controller/user_controller.dart';
import 'package:awesomethink/controller/work_controller.dart';
import 'package:awesomethink/data/model/work.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkInOutBtn extends StatefulWidget {
  WorkInOutBtn(
      {Key? key, }): super(key: key);



  @override
  _WorkInOutBtnState createState() =>
      _WorkInOutBtnState();
}

class _WorkInOutBtnState extends State<WorkInOutBtn> {
  late final WorkController workController;
  late final UserController userController;
  List<Work?>? weeklyWorkList;
  Work? today;

  _WorkInOutBtnState();


  @override
  void initState() {
    workController = Get.find<WorkController>();
    userController = Get.find<UserController>();
    weeklyWorkList = workController.getWeeklyWorkList();
  }


  bool checkDuplication(){
    int? year = weeklyWorkList?.first?.startTime?.year;
    int? month = weeklyWorkList?.first?.startTime?.month;
    int? day = weeklyWorkList?.first?.startTime?.day;
    bool result = true;
    for(Work? w in weeklyWorkList!){
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

  void startTodayWorkingTime() {
    //당일 중복등록 못하게 validation
    bool check = checkDuplication();

    //당일 첫 출근인경우
    if (check) {
      today = Work().createWork(userController.userInfo.uid);
      //work doc 생성
      workController.setWork(today);
      //당일에 퇴근후 출근 또누른경우
    } else {
      Get.snackbar("당일 중복등록 불가", "같은날 기록이 중복될 수 없습니다");
    }
  }

  void endTodayWorkingTime() async {
    //TODO dialog나 snackbar로 확인후 퇴근 처리되게 변경할것
    today?.endTime = DateTime.now();
    workController.updateWork(today);
  }

  //퇴근체크
  bool isOut(){
    bool result = true;
    for(Work? w in weeklyWorkList!){
      if(w!.endTime==null){
        result = false;
        break;
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {

    //case 1. 출근기록 X --> list empty
    if(weeklyWorkList!.isEmpty) {
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
    if(!isOut()){
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

