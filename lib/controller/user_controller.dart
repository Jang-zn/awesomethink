
import 'package:awesomethink/data/model/member.dart';
import 'package:awesomethink/data/repository/user_repo.dart';
import 'package:get/get.dart';

class UserController extends GetxController{
  final UserRepository userRepository;

  UserController({required this.userRepository});

  final _userInfo = Member().obs;
  final _newbieList = <Member>[].obs;
  final _memberList = <Member>[].obs;

  get userInfo => _userInfo.value;
  set userInfo(value) => _userInfo.value;
  get newbieList => _newbieList;
  set newbieList(value) => _newbieList;
  get memberList => _memberList;
  set memberList(value) => _memberList;

  void updateUserInfo(){
    userInfo = userRepository.getUserInfo();
  }

  void updateNewbieList(){
    newbieList = userRepository.getNewbieList();
  }

  void updateMemberList(){
    memberList = userRepository.getMemberList();
  }

}
