
import 'package:awesomethink/data/model/member.dart';
import 'package:awesomethink/data/repository/user_repo.dart';
import 'package:get/get.dart';

class UserController extends GetxController{
  final UserRepository userRepository = UserRepository();

  UserController();
  //현재 유저정보
  final Rxn<Member?> _userInfo = Rxn<Member?>();

  //state false 인 유저
  final RxList<Member?> _newbieList = RxList<Member?>();

  //state true 인 유저
  final RxList<Member?> _memberList = RxList<Member?>();

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
    _newbieList(await userRepository.getNewbieList());
    _newbieList.refresh();
  }

  Future<void> getMemberList() async{
    _memberList(await userRepository.getMemberList());
    _memberList.refresh();
  }

  Future<void> updateUserInfo(Member? user) async{
    await userRepository.updateUserInfo(user);
    await getNewbieList();
    await getMemberList();
    await getUserInfo(user!.uid);
  }

  Future<void> setUserInfo(Member user) async{
    await userRepository.setUserInfo(user);
    await getNewbieList();
    await getMemberList();
  }

}
