import 'package:awesomethink/data/model/work.dart';
import 'package:awesomethink/data/provider/work_provider.dart';

class WorkRepository{
  final WorkProvider workProvider = WorkProvider();


  Future<Stream<List<Work?>>> getWeeklyWorkList(String? uid) async {
      return (await workProvider.getWeeklyWorkList(uid)).map(
              (snapshot) {
                final List<Work?> list = <Work?>[];
                snapshot.docs.forEach((element) {
                  print("getWeeklyList from repository "+Work.fromJson(element.data()).toString());
                  list.add(Work.fromJson(element.data()));
                });
                return list;
              }
      );
  }

  Stream<List<Work?>> getMonthlyWorkList(String? uid, DateTime dateTime) {
    return workProvider.getMonthlyWorkList(uid, dateTime).map(
            (snapshot) {
              final List<Work?> list = <Work?>[];
              snapshot.docs.forEach((element) {
                list.add(Work.fromJson(element.data()));
              });
              return list;
            }
    );
  }


  Future<Stream<List<Work?>>> updateWorkingTimeState(Work? work, int state) async {
    return (await workProvider.updateWorkingTimeState(work, state)).map(
            (snapshot) {
          final List<Work?> list = <Work?>[];
          snapshot.docs.forEach((element) {
            print("updateWorkingTimeState from repository "+Work.fromJson(element.data()).toString());
            list.add(Work.fromJson(element.data()));
          });
          return list;
        }
    );
  }


  Future<void> setWork(Work? work) async {
    await workProvider.setWork(work);
  }


  Future<Stream<List<Work?>>> updateWork(Work? work) async {
    return (await workProvider.updateWork(work)).map(
            (snapshot) {
          final List<Work?> list = <Work?>[];
          snapshot.docs.forEach((element) {
            print("updateWork from repository "+Work.fromJson(element.data()).toString());
            list.add(Work.fromJson(element.data()));
          });
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

  //임시기능
  void deleteAllWork(){
    workProvider.deleteAllWork();
  }
}

