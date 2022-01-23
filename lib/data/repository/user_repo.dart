
import 'package:awesomethink/data/model/member.dart';
import 'package:awesomethink/data/provider/user_provider.dart';
import 'package:awesomethink/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

class UserRepository{
  final UserProvider userProvider = UserProvider();

  UserRepository();

  Future<List<Member>> getNewbieList() async{
    return (await userProvider.getNewbieList())
        .map(
            (snapshot) => snapshot.docs
                .map((doc)=> Member.fromJson(doc.data()))
                .toList()
        ).single;
  }

  Future<List<Member>> getMemberList() async{
    return (await userProvider.getMemberList())
        .map(
            (snapshot) => snapshot.docs
            .map((doc)=> Member.fromJson(doc.data()))
            .toList()
    ).single;
  }

  Future<Member> getUserInfo(String? uid) async{
    return Member.fromJson(await userProvider.getUserInfoByUid(uid) as Map<String, dynamic>);

  }

  Future<bool?> updateUserInfo(Member? user) async{
    return await userProvider.updateUserInfo(user);
  }

  Future<void> setUserInfo(Member user) async{
    return await userProvider.setUserInfo(user);
  }






}