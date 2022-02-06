import 'package:awesomethink/data/model/work.dart';
import 'package:awesomethink/data/provider/work_provider.dart';

class WorkRepository{
  final WorkProvider workProvider = WorkProvider();


  Future<Stream<List<Work?>>> getWeeklyWorkList(String? uid) async {
      return (await workProvider.getWeeklyWorkList(uid)).map(
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
    return (await workProvider.getVacationList()).map(
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
    return (await workProvider.getMonthlyWorkList(uid, dateTime)).map(
            (snapshot) {
              final List<Work?> list = <Work?>[];
              for(var element in snapshot.docs) {
                list.add(Work.fromJson(element.data()));
              }
              return list;
            }
    );
  }


  Future<Stream<List<Work?>>> updateWorkingTimeState(Work? work, int state) async {
    return (await workProvider.updateWorkingTimeState(work, state)).map(
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
    return (await workProvider.acceptVacation(vacation)).map(
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
    return (await workProvider.rejectVacation(vacation)).map(
            (snapshot) {
          final List<Work?> list = <Work?>[];
          for(var element in snapshot.docs) {
            list.add(Work.fromJson(element.data()));
          }
          return list;
        }
    );
  }


  Future<void> setWork(Work? work) async {
    await workProvider.setWork(work);
  }

  Future<Work?> getTodayWork(DateTime today) async {
    return Work.fromJson((await workProvider.getTodayWork(today)).docs.first.data());
  }


  Future<Stream<List<Work?>>> updateWork(Work? work) async {
    return (await workProvider.updateWork(work)).map(
            (snapshot) {
          final List<Work?> list = <Work?>[];
          for(var element in snapshot.docs) {
            list.add(Work.fromJson(element.data()));
          }
          return list;
        }
    );
  }

  Future<Work?> getWorkByStartTime(Work? work) async {
    return await (workProvider.getWorkByStartTime(work)).map(
            (snapshot)=>snapshot.docs.map(
                (doc)=>Work.fromJson(doc.data()!)).first
    ).first;
  }

  // //임시기능
  // void deleteAllWork(){
  //   workProvider.deleteAllWork();
  // }
}

