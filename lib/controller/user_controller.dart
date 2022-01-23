
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


  void getUserInfo(String? uid) async{
    userInfo.value = await userRepository.getUserInfo(uid);
  }

  void getNewbieList() async{
    newbieList = await userRepository.getNewbieList();
  }

  void getMemberList() async{
    memberList = await userRepository.getMemberList();
  }

  void updateUserInfo(Member? user) async{
    bool? result = await userRepository.updateUserInfo(user);
    if(result!){
     getNewbieList();
    }
  }

}
