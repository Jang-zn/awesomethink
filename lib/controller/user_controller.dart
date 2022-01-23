
import 'package:awesomethink/data/model/member.dart';
import 'package:awesomethink/data/repository/user_repo.dart';
import 'package:get/get.dart';

class UserController extends GetxController{
  final UserRepository userRepository = UserRepository();

  UserController();
  //현재 유저정보
  final _userInfo = Member().obs;

  //state false 인 유저
  final _newbieList = <Member>[].obs;

  //state true 인 유저
  final _memberList = <Member>[].obs;

  get userInfo => _userInfo.value;
  set userInfo(value) => _userInfo.value;
  get newbieList => _newbieList;
  set newbieList(value) => _newbieList;
  get memberList => _memberList;
  set memberList(value) => _memberList;


  Future<void> getUserInfo(String? uid) async{
    userInfo.value = await userRepository.getUserInfo(uid);
  }

  Future<void> getNewbieList() async{
    newbieList = await userRepository.getNewbieList();
  }

  Future<void> getMemberList() async{
    memberList = await userRepository.getMemberList();
  }

  Future<void> updateUserInfo(Member? user) async{
    await userRepository.updateUserInfo(user);
    getNewbieList();
    getMemberList();
    getUserInfo(user!.uid);
  }

  Future<void> setUserInfo(Member user) async{
    await userRepository.setUserInfo(user);
    getNewbieList();
    getMemberList();
  }

}
