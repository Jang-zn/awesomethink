
// ignore_for_file: avoid_print

import 'package:awesomethink/data/model/work.dart';
import 'package:awesomethink/data/repository/work_repo.dart';
import 'package:get/get.dart';

class WorkController extends GetxController{
  final WorkRepository workRepository = WorkRepository();
  String? uid;
  WorkController(this.uid);

  final RxBool _inOut = true.obs;
  final RxList<Work?> _monthlyWorkList = <Work?>[].obs;
  final RxList<Work?> _weeklyWorkList = <Work?>[].obs;
  final RxString _weeklyWorkingTime ="0시간 00분".obs;
  final RxString _monthlyWorkingTime ="0시간 00분".obs;
  final RxString _requiredWorkingTime ="40시간 00분".obs;

  get monthlyWorkList => _monthlyWorkList;
  set monthlyWorkList(value) => _monthlyWorkList;

  get weeklyWorkList => _weeklyWorkList;
  set weeklyWorkList(value) => _weeklyWorkList;

  get weeklyWorkingTime => _weeklyWorkingTime;
  set weeklyWorkingTime(value) => _weeklyWorkingTime;

  get monthlyWorkingTime => _monthlyWorkingTime;
  set monthlyWorkingTime(value) => _monthlyWorkingTime;

  get requiredWorkingTime => _requiredWorkingTime;
  set requiredWorkingTime(value) => _requiredWorkingTime;

  get inOut => _inOut.value;
  set inOut(value) => _inOut;



  Future<void> getAllWorkList(String? uid, DateTime dateTime) async{
    await Future.wait([
      getWeeklyWorkList(uid),
      getMonthlyWorkList(uid, dateTime)
    ]);
    refresh();
  }

  Future<void> getWeeklyWorkList(String? uid) async{
    _weeklyWorkList.value = await (await workRepository.getWeeklyWorkList(uid)).first;
    getWeeklyWorkingTime();
    checkInOut();
    refresh();
  }

  Future<void> getMonthlyWorkList(String? uid, DateTime dateTime) async {
    _monthlyWorkList.value = await (await workRepository.getMonthlyWorkList(uid, dateTime)).first;
    _monthlyWorkList.refresh();
  }


  Future<Work?> getTodayWork(DateTime today){
    return workRepository.getTodayWork(today);
  }

  Future<void> updateWorkingTimeState(Work? work, int state) async {
    _weeklyWorkList.value = await (await workRepository.updateWorkingTimeState(work, state)).first;
    refresh();
  }

  Future<void> updateWork(Work? work) async{
    _weeklyWorkList.value = await (await workRepository.updateWork(work)).first;
    getWeeklyWorkingTime();
    checkInOut();
    refresh();
  }

  Future<void> setWork(Work? work) async{
    await Future.wait([
      workRepository.setWork(work),
      getAllWorkList(work!.userUid, DateTime.now())
    ]);
    refresh();
  }

  void getWeeklyWorkingTime() {
    //변수
    int weeklyHour=0;
    int weeklyMinute=0;
    int requiredHour=39;
    int requiredMinute=60;
    try {
      for (Work? w in _weeklyWorkList) {
        Map<String, int> timeMap = w!.getWorkingTimeToMap();
        weeklyHour += timeMap["hour"]!;
        weeklyMinute += timeMap["minute"]!;
      }

      // 분 합계가 60분 이상이면 단위 올려줌
      if (weeklyMinute > 59) {
        weeklyHour += (weeklyMinute - weeklyMinute % 60) ~/ 60;
        weeklyMinute = weeklyMinute % 60;
      }

      //requiredHour / Minute 처리
      requiredHour = requiredHour - weeklyHour;
      requiredMinute = requiredMinute - weeklyMinute;
      if (requiredHour < 0) {
        requiredHour = 0;
        requiredMinute = 0;
      }

      if (requiredMinute == 60) {
        requiredMinute = 0;
        requiredHour += 1;
      }

      //출력메세지 세팅
      if(weeklyMinute>0){
        _weeklyWorkingTime.value = weeklyHour.toString() + "시간 " + weeklyMinute.toString() + "분";
      }else{
        _weeklyWorkingTime.value = weeklyHour.toString() + "시간 " + "0" + weeklyMinute.toString() + "분";
      }

      if(requiredMinute>0){
        _requiredWorkingTime.value = requiredHour.toString() + "시간 " + requiredMinute.toString()+"분";
      }else{
        _requiredWorkingTime.value = requiredHour.toString() + "시간 " + "0" + requiredMinute.toString() +"분";
      }

      _weeklyWorkingTime.refresh();
      _requiredWorkingTime.refresh();

    }catch(e){
      print("calc error : "+e.toString());
    }
  }

  void checkInOut(){
    for(Work? w in _weeklyWorkList) {
      if(!w!.checkOut!){
        _inOut(false);
        _inOut.refresh();
        return;
      }
    }
    _inOut(true);
    _inOut.refresh();
  }

  // //임시기능
  // void deleteAllWork(){
  //   workRepository.deleteAllWork();
  // }

}
