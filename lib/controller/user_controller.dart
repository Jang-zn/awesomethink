import 'package:awesomethink/data/model/member.dart';
import 'package:awesomethink/data/model/work.dart';
import 'package:awesomethink/data/repository/user_repo.dart';
import 'package:get/get.dart';

class UserController extends GetxController{
  final UserRepository userRepository = UserRepository();

  UserController();
  //현재 유저정보
  final Rxn<Member?> _userInfo = Rxn<Member?>();

  //state false 인 유저
  final RxList<Member?> _newbieList = <Member?>[].obs;

  //state true 인 유저
  final RxList<Member?> _memberList = <Member?>[].obs;

  //오늘 근무관련 data
  final  RxList<Work?> _todayWorkList = <Work?>[].obs;
  final  RxList<Member?> _todayMemberList = <Member?>[].obs;


  get todayMemberList => _todayMemberList;
  set todayMemberList(value) => _todayMemberList;
  get todayWorkList => _todayWorkList;
  set todayWorkList(value) => _todayWorkList;
  get userInfo => _userInfo.value;
  set userInfo(value) => _userInfo.value;
  get newbieList => _newbieList;
  set newbieList(value) => _newbieList;
  get memberList => _memberList;
  set memberList(value) => _memberList;



  Future<void> getUserInfo(String? uid) async{
    _userInfo(await userRepository.getUserInfo(uid));
    _userInfo.refresh();
  }

  Future<void> getNewbieList() async{
    _newbieList.value = await (await userRepository.getNewbieList()).first;
    _newbieList.refresh();
  }

  Future<void> getMemberList() async{
    _memberList.value = await (await userRepository.getMemberList()).first;
    _memberList.refresh();
  }

  Future<void> updateUserInfo(Member? user) async{
    Future.wait
      ([userRepository.updateUserInfo(user),
        getNewbieList(),
        getMemberList(),
        getUserInfo(user!.uid),
    ]);
  }

  Future<void> setUserInfo(Member user) async{
    await userRepository.setUserInfo(user);
    await getNewbieList();
    await getMemberList();
  }


  //오늘 출퇴근 확인
  Future<void> getTodayWorkList() async{
    _todayWorkList.value = await (await userRepository.getTodayWorkList()).first;
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



}
