import 'package:awesomethink/data/model/member.dart';
import 'package:awesomethink/data/repository/user_repo.dart';
import 'package:get/get.dart';

class UserController extends GetxController{
  final UserRepository userRepository = UserRepository();

  UserController();
  //현재 유저정보
  final Rxn<Member?> _userInfo = Rxn<Member?>();

  get userInfo => _userInfo.value;
  set userInfo(value) => _userInfo.value;


  Future<void> getUserInfo(String? uid) async{
    _userInfo(await userRepository.getUserInfo(uid));
    _userInfo.refresh();
  }

  Future<void> updateUserInfo(Member? user) async{
    Future.wait
      ([userRepository.updateUserInfo(user),
        getUserInfo(user!.uid),
    ]);
  }

  Future<void> setUserInfo(Member user) async{
    await userRepository.setUserInfo(user);
  }
}
