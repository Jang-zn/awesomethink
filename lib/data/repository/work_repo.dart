import 'package:awesomethink/data/model/work.dart';
import 'package:awesomethink/data/provider/work_provider.dart';

class WorkRepository{
  final WorkProvider workProvider = WorkProvider();


  Stream<List<Work?>> getWeeklyWorkList(String? uid) {
      return workProvider.getWeeklyWorkList(uid).map(
              (snapshot) {
                final List<Work?> list = <Work?>[];
                snapshot.docs.forEach((element) {
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


  Future<void> updateWorkingTimeState(Work? work, int state) async {
    await workProvider.updateWorkingTimeState(work, state);
  }


  Future<void> setWork(Work? work) async {
    await workProvider.setWork(work);
  }


  Future<void> updateWork(Work? work) async{
    await workProvider.updateWork(work);
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

