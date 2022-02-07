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
  final RxList<Work?> _vacationList = <Work?>[].obs;

  get vacationList => _vacationList;
  set vacationList(value) => _vacationList;




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
  
}