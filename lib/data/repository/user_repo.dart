
import 'package:awesomethink/data/model/member.dart';
import 'package:awesomethink/data/provider/user_provider.dart';
import 'package:awesomethink/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

class UserRepository{
  final UserProvider userProvider;
  final User? currentUser;
  Member? userInfo;
  List<Member?>? newbieList;
  List<Member?>? memberList;
  Logger logger = Logger();

  UserRepository({required this.userProvider, required this.currentUser}){
    setUserInfo().then(
            (value){logger.d("init UserRepository"+userInfo.toString());
            logger.d(currentUser);
            });
    if(userInfo?.type==UserType.admin.index){
      setNewbieList();
      setMemberList();
    }
  }

  Future<bool> setUserInfo() async{
    userInfo = Member.fromJson(await userProvider.getUserInfoByUid(currentUser!.uid) as Map<String, dynamic>);
    return true;
  }

  void setNewbieList() async {
    newbieList = await userProvider.getNewbieList();
  }

  void setMemberList() async {
    memberList = await userProvider.getMemberList();
  }

  List<Member?>? getNewbieList(){
    return newbieList;
  }

  List<Member?>? getMemberList(){
    return memberList;
  }

  Member? getUserInfo(){
    return userInfo;
  }

  Future<bool?> updateUserInfo(Member? user) async{
    return await userProvider.updateUserInfo(user);
  }




}