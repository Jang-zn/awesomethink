
import 'package:awesomethink/data/model/member.dart';
import 'package:awesomethink/data/model/work.dart';
import 'package:awesomethink/data/provider/admin_provider.dart';

class AdminRepository{
  final AdminProvider adminProvider = AdminProvider();

  Future<Stream<List<Member?>>> getNewbieList() async {
    return (await adminProvider.getNewbieList()).map((snapshot) {
      final List<Member?> list = <Member?>[];
      for (var element in snapshot.docs) {
        list.add(Member.fromJson(element.data()));
      }
      return list;
    });
  }

  Future<Stream<List<Member?>>> getMemberList() async {
    return (await adminProvider.getMemberList()).map(
            (snapshot) {
          final List<Member?> list = <Member?>[];
          for (var element in snapshot.docs) {
            list.add(Member.fromJson(element.data()));
          }
          return list;
        });
  }

  //오늘 출퇴근 현황보기 위한 toadyWorkList
  Future<Stream<List<Work?>>> getTodayWorkList() async {
    return (await adminProvider.getTodayWorkList()).map((snapshot) {
      final List<Work?> list = <Work?>[];
      for (var element in snapshot.docs) {
        list.add(Work.fromJson(element.data()));
      }
      return list;
    });
  }

  Future<Stream<List<Work?>>> getWeeklyWorkList(String? uid) async {
    return (await adminProvider.getWeeklyWorkList(uid)).map(
            (snapshot) {
          final List<Work?> list = <Work?>[];
          for(var element in snapshot.docs) {
            list.add(Work.fromJson(element.data()));
          }
          return list;
        }
    );
  }

  Future<Stream<List<Work?>>> getVacationList() async {
    return (await adminProvider.getVacationList()).map(
            (snapshot) {
          final List<Work?> list = <Work?>[];
          for(var element in snapshot.docs) {
            list.add(Work.fromJson(element.data()));
          }
          return list;
        }
    );
  }

  Future<Stream<List<Work?>>> getMonthlyWorkList(String? uid, DateTime dateTime) async {
    return (await adminProvider.getMonthlyWorkList(uid, dateTime)).map(
            (snapshot) {
          final List<Work?> list = <Work?>[];
          for(var element in snapshot.docs) {
            list.add(Work.fromJson(element.data()));
          }
          return list;
        }
    );
  }

  Future<Stream<List<Work?>>> acceptVacation(Work? vacation) async {
    return (await adminProvider.acceptVacation(vacation)).map(
            (snapshot) {
          final List<Work?> list = <Work?>[];
          for(var element in snapshot.docs) {
            list.add(Work.fromJson(element.data()));
          }
          return list;
        }
    );
  }

  Future<Stream<List<Work?>>> rejectVacation(Work? vacation) async {
    return (await adminProvider.rejectVacation(vacation)).map(
            (snapshot) {
          final List<Work?> list = <Work?>[];
          for(var element in snapshot.docs) {
            list.add(Work.fromJson(element.data()));
          }
          return list;
        }
    );
  }
  
}