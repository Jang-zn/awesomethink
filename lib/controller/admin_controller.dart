import 'package:awesomethink/data/model/member.dart';
import 'package:awesomethink/data/model/work.dart';
import 'package:awesomethink/data/repository/admin_repo.dart';
import 'package:get/get.dart';

class AdminController extends GetxController{

  final AdminRepository adminRepository = AdminRepository();

  //오늘 근무관련 data
  final  RxList<Work?> _todayWorkList = <Work?>[].obs;
  final  RxList<Member?> _todayMemberList = <Member?>[].obs;

  //state false 인 유저
  final RxList<Member?> _newbieList = <Member?>[].obs;

  //state true 인 유저
  final RxList<Member?> _memberList = <Member?>[].obs;
  
  //Work 관련 Data
  final RxList<Work?> _monthlyWorkList = <Work?>[].obs;
  final RxList<Work?> _weeklyWorkList = <Work?>[].obs;
  final RxList<Work?> _vacationList = <Work?>[].obs;
  final RxString _weeklyWorkingTime ="0시간 00분".obs;
  final RxString _monthlyWorkingTime ="0시간 00분".obs;
  final RxString _requiredWorkingTime ="40시간 00분".obs;

  get monthlyWorkList => _monthlyWorkList;
  set monthlyWorkList(value) => _monthlyWorkList;

  get weeklyWorkList => _weeklyWorkList;
  set weeklyWorkList(value) => _weeklyWorkList;

  get vacationList => _vacationList;
  set vacationList(value) => _vacationList;

  get weeklyWorkingTime => _weeklyWorkingTime;
  set weeklyWorkingTime(value) => _weeklyWorkingTime;

  get monthlyWorkingTime => _monthlyWorkingTime;
  set monthlyWorkingTime(value) => _monthlyWorkingTime;

  get requiredWorkingTime => _requiredWorkingTime;
  set requiredWorkingTime(value) => _requiredWorkingTime;
  


  get todayMemberList => _todayMemberList;
  set todayMemberList(value) => _todayMemberList;
  get todayWorkList => _todayWorkList;
  set todayWorkList(value) => _todayWorkList;
  get newbieList => _newbieList;
  set newbieList(value) => _newbieList;
  get memberList => _memberList;
  set memberList(value) => _memberList;


  Future<void> getNewbieList() async{
    _newbieList.value = await (await adminRepository.getNewbieList()).first;
    _newbieList.refresh();
  }

  Future<void> getMemberList() async{
    _memberList.value = await (await adminRepository.getMemberList()).first;
    _memberList.refresh();
  }

  //오늘 출퇴근 확인
  Future<void> getTodayWorkList() async{
    _todayWorkList.value = await (await adminRepository.getTodayWorkList()).first;
    _todayMemberList.value =getTodayMemberList();
    _todayMemberList.refresh();
  }

  //출퇴근 workList가지고 todayMemberList 갱신
  List<Member?> getTodayMemberList() {
    List<Member?> today=[];
    for(Work? w in _todayWorkList){
      for(Member? m in _memberList){
        if(w!.userUid==m!.uid){
          today.add(m);
          break;
        }
      }
    }
    return today;
  }

  Future<void> getAllWorkList(String? uid, DateTime dateTime) async{
    await Future.wait([
      getWeeklyWorkList(uid),
      getMonthlyWorkList(uid, dateTime)
    ]);
    refresh();
  }

  Future<void> getWeeklyWorkList(String? uid) async{
    _weeklyWorkList.value = await (await adminRepository.getWeeklyWorkList(uid)).first;
    getWeeklyWorkingTime();
    refresh();
  }

  Future<void> getMonthlyWorkList(String? uid, DateTime dateTime) async {
    _monthlyWorkList.value = await (await adminRepository.getMonthlyWorkList(uid, dateTime)).first;
    _monthlyWorkList.refresh();
  }

  Future<void> getVacationList() async {
    List<Work?> list = await (await adminRepository.getVacationList()).first;
    List<Work?> result = [];
    for(Work? w in list){
      //result 비었으면 걍 하나 추가
      if(result.isEmpty){
        result.add(w);
        continue;
      }
      //result 안비어있으면
      for(int i=0;i<result.length;i++){
        //UID 같고, 휴가 시작일이 같으면(이미 result에 휴가로 지정되어있으면) break --> 더 볼거 없음
        if(w!.userUid==result[i]!.userUid&&w.vacation!.startVacation==result[i]!.vacation!.startVacation){
          break;
        }
        //다르면 result 전부랑 비교해봤는지 체크하고 끝이면 add
        if(i==result.length-1){
          result.add(w);
        }
      }
    }
    _vacationList.value =result;
    _vacationList.refresh();
  }

  Future<void> acceptVacation(Work? vacation) async{
    List<Work?> list = await (await adminRepository.acceptVacation(vacation)).first;
    List<Work?> result = [];
    for(Work? w in list){
      //result 비었으면 걍 하나 추가
      if(result.isEmpty){
        result.add(w);
        continue;
      }
      //result 안비어있으면
      for(int i=0;i<result.length;i++){
        //UID 같고, 휴가 시작일이 같으면(이미 result에 휴가로 지정되어있으면) break --> 더 볼거 없음
        if(w!.userUid==result[i]!.userUid&&w.vacation!.startVacation==result[i]!.vacation!.startVacation){
          break;
        }
        //다르면 result 전부랑 비교해봤는지 체크하고 끝이면 add
        if(i==result.length-1){
          result.add(w);
        }
      }
    }
    _vacationList.value =result;
    _vacationList.refresh();
  }

  Future<void> rejectVacation(Work? vacation) async{
    List<Work?> list = await (await adminRepository.rejectVacation(vacation)).first;
    List<Work?> result = [];
    for(Work? w in list){
      //result 비었으면 걍 하나 추가
      if(result.isEmpty){
        result.add(w);
        continue;
      }
      //result 안비어있으면
      for(int i=0;i<result.length;i++){
        //UID 같고, 휴가 시작일이 같으면(이미 result에 휴가로 지정되어있으면) break --> 더 볼거 없음
        if(w!.userUid==result[i]!.userUid&&w.vacation!.startVacation==result[i]!.vacation!.startVacation){
          break;
        }
        //다르면 result 전부랑 비교해봤는지 체크하고 끝이면 add
        if(i==result.length-1){
          result.add(w);
        }
      }
    }
    _vacationList.value =result;
    _vacationList.refresh();
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
        requiredWorkingTime = requiredHour.toString() + "시간 " + "0" + requiredMinute.toString() +"분";
      }

      _weeklyWorkingTime.refresh();
      _requiredWorkingTime.refresh();

    }catch(e){
      print("calc error : "+e.toString());
    }
  }
  
}