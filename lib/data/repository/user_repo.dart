import 'package:awesomethink/data/model/member.dart';
import 'package:awesomethink/data/provider/user_provider.dart';

class UserRepository{
  final UserProvider userProvider = UserProvider();

  UserRepository();

  Future<List<Member?>> getNewbieList() {
    return (userProvider.getNewbieList())
        .map(
            (snapshot) => snapshot.docs
                .map((doc)=> Member.fromJson(doc.data()!))
                .toList()
        ).first;
  }

  Future<List<Member?>> getMemberList() {
    return (userProvider.getMemberList())
        .map(
            (snapshot) => snapshot.docs
            .map((doc)=> Member.fromJson(doc.data()!))
            .toList()
    ).first;
  }

  Future<Member?> getUserInfo(String? uid) async{
    return await (userProvider.getUserInfoByUid(uid)).map(
        (snapshot)=>snapshot.docs.map(
            (doc)=>Member.fromJson(doc.data()!)).first
    ).first;
  }

  Future<void> updateUserInfo(Member? user) async{
    await userProvider.updateUserInfo(user);
  }

  Future<void> setUserInfo(Member? user) async{
    return await userProvider.setUserInfo(user!);
  }






}