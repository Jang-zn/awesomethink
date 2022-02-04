import 'package:awesomethink/data/model/member.dart';
import 'package:awesomethink/data/model/work.dart';
import 'package:awesomethink/data/provider/user_provider.dart';

class UserRepository {
  final UserProvider userProvider = UserProvider();

  UserRepository();

  Future<Stream<List<Member?>>> getNewbieList() async {
    return (await userProvider.getNewbieList()).map((snapshot) {
      final List<Member?> list = <Member?>[];
      for (var element in snapshot.docs) {
        list.add(Member.fromJson(element.data()));
      }
      return list;
    });
  }

  Future<Stream<List<Member?>>> getMemberList() async {
    return (await userProvider.getMemberList()).map((snapshot) {
      final List<Member?> list = <Member?>[];
      for (var element in snapshot.docs) {
        list.add(Member.fromJson(element.data()));
      }
      return list;
    });
  }

  //오늘 출퇴근 현황보기 위한 toadyWorkList
  Future<Stream<List<Work?>>> getTodayWorkList() async {
    return (await userProvider.getTodayWorkList()).map((snapshot) {
      final List<Work?> list = <Work?>[];
      for (var element in snapshot.docs) {
        list.add(Work.fromJson(element.data()));
      }
      return list;
    });
  }

  Future<Member?> getUserInfo(String? uid) async {
    return await (userProvider.getUserInfoByUid(uid))
        .map((snapshot) =>
            snapshot.docs.map((doc) => Member.fromJson(doc.data()!)).first)
        .first;
  }

  Future<void> updateUserInfo(Member? user) async {
    await userProvider.updateUserInfo(user);
  }

  Future<void> setUserInfo(Member? user) async {
    return await userProvider.setUserInfo(user!);
  }
}
