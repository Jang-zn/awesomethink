import 'package:awesomethink/data/model/work.dart';
import 'package:awesomethink/data/provider/work_provider.dart';

class WorkRepository{
  final WorkProvider workProvider = WorkProvider();


  Future<List<Work?>> getWeeklyWorkList(String? uid) async {
    List<Work?> result=[];
    (await workProvider.getWeeklyWorkList(uid)).snapshots().map(
            (snapshot) => snapshot.docs.map(
                (doc) {
                  result.add(Work.fromJson(doc.data()));
                }
        )
    );
    return result;
  }

  Future<List<Work?>> getMonthlyWorkList(String? uid, DateTime dateTime) async {
    List<Work?> result = [];
    (await workProvider.getMonthlyWorkList(uid, dateTime)).snapshots().map(
            (snapshot) => snapshot.docs.map(
                (doc) {
                  result.add(Work.fromJson(doc.data()));
                }
        )
    );
    return result;
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

