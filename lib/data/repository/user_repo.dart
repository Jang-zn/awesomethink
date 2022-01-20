
import 'package:awesomethink/data/model/member.dart';
import 'package:awesomethink/data/provider/user_provider.dart';
import 'package:awesomethink/utils/constants.dart';
import 'package:firebase/firebase.dart';
import 'package:logger/logger.dart';

class UserRepository{
  final UserProvider userProvider;
  final User? currentUser;
  Member? userInfo;
  List<Member?>? newbieList;
  List<Member?>? memberList;
  Logger logger = Logger();

  UserRepository({required this.userProvider, required this.currentUser}){
    setUserInfo();
    if(userInfo?.type==UserType.admin.index){
      setNewbieList();
      setMemberList();
    }
    logger.d("init UserRepository");

  }

  void setUserInfo(){
    userInfo = Member.fromJson(userProvider.getUserInfoByUid(currentUser!.uid) as Map<String, dynamic>);
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

  Member? getUserInfo(){
    return userInfo;
  }


}