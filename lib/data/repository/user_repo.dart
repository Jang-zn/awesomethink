import 'package:awesomethink/data/model/member.dart';
import 'package:awesomethink/data/model/work.dart';
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

  //오늘 출퇴근 현황보기 위한 toadyWorkList
  Future<Stream<List<Work?>>> getTodayWorkList() async {
    return (await userProvider.getTodayWorkList()).map(
            (snapshot) {
          final List<Work?> list = <Work?>[];
          snapshot.docs.forEach((element) {
            list.add(Work.fromJson(element.data()));
          });
          return list;
        }
    );
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