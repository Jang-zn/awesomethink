
import 'package:awesomethink/data/model/work.dart';
import 'package:awesomethink/data/repository/work_repo.dart';
import 'package:get/get.dart';

class WorkController extends GetxController{
  final WorkRepository workRepository = WorkRepository();
  String? uid;
  WorkController(this.uid);

  final RxBool _inOut = true.obs;
  final  RxList<Work?> _monthlyWorkList = <Work?>[].obs;
  final  RxList<Work?> _weeklyWorkList = <Work?>[].obs;
  final RxString _weeklyWorkingTime ="0시간 00분".obs;
  final RxString _monthlyWorkingTime ="0시간 00분".obs;
  final RxString _requiredWorkingTime ="40시간 00분".obs;

  get monthlyWorkList => _monthlyWorkList;
  get weeklyWorkList => _weeklyWorkList;
  set weeklyWorkList(value) => _weeklyWorkList;
  set monthlyWorkList(value) => _monthlyWorkList;
  get weeklyWorkingTime => _weeklyWorkingTime;
  set weeklyWorkingTime(value) => _weeklyWorkingTime;
  get monthlyWorkingTime => _monthlyWorkingTime;
  set monthlyWorkingTime(value) => _monthlyWorkingTime;
  get requiredWorkingTime => _requiredWorkingTime;
  set requiredWorkingTime(value) => _requiredWorkingTime;
  get inOut => _inOut.value;
  set inOut(value) => _inOut;


  @override
  void onInit() {
    ever(_weeklyWorkList,
            (_) {
              print("changed : ${_weeklyWorkList.toString()}");
              update();
            });
  }

  Future<void> getAllWorkList(String? uid, DateTime dateTime) async{
    print("getAllWorkList");
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
    print("getWeeklyWorkList");
    refresh();
  }

  Future<void> getMonthlyWorkList(String? uid, DateTime dateTime) async {
    _monthlyWorkList.value = await (await workRepository.getMonthlyWorkList(uid, dateTime)).first;
    refresh();
  }

  Future<void> updateWorkingTimeState(Work? work, int state) async {
    print("updateWorkingTimeState");
    _weeklyWorkList.value = await (await workRepository.updateWorkingTimeState(work, state)).first;
    refresh();
  }

  Future<void> updateWork(Work? work) async{
    print("updateWork");
    _weeklyWorkList.value = await (await workRepository.updateWork(work)).first;
    refresh();
  }

  Future<void> setWork(Work? work) async{
    print("setWork");
    await Future.wait([
      workRepository.setWork(work),
      getAllWorkList(work!.userUid, DateTime.now())
    ]);
    refresh();
  }

  void getWeeklyWorkingTime() {
    print("getWeeklyWorkingTime");
    print("주간 시간계산");
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
      weeklyMinute > 0 ?
      weeklyWorkingTime.value =
          weeklyHour.toString() + "시간 " + weeklyMinute.toString() + "분"
          : weeklyWorkingTime =
          weeklyHour.toString() + "시간 " + "0" + weeklyMinute.toString() + "분";
      requiredMinute > 0 ?
      requiredWorkingTime.value =
          requiredHour.toString() + "시간 " + requiredMinute.toString() + "분"
          : requiredWorkingTime =
          requiredHour.toString() + "시간 " + "0" + requiredMinute.toString() +
              "분";
      update();
    }catch(e){
      print("calc error : "+e.toString());
      update();
    }
  }

  void checkInOut(){
    print("checkInOut");
    for(Work? w in _weeklyWorkList) {
      if(!w!.checkOut!){
        _inOut(false);
        refresh();
        return;
      }
    }
    _inOut(true);
    refresh();
  }

  //임시기능
  void deleteAllWork(){
    workRepository.deleteAllWork();
  }

}
