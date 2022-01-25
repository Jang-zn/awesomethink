
import 'package:awesomethink/data/model/member.dart';
import 'package:awesomethink/data/model/work.dart';
import 'package:awesomethink/data/provider/work_provider.dart';
import 'package:logger/logger.dart';

class WorkRepository{
  final WorkProvider workProvider = WorkProvider();


  Future<List<Work?>> getWeeklyWorkList(String? uid) async {
    return (await workProvider.getWeeklyWorkList(uid))
        .snapshots().map(
            (snapshot) => snapshot.docs.map(
                (doc) => Work
                .fromJson(doc.data())
        ).toList()
    ).first;
  }

  Future<List<Work?>> getMonthlyWorkList(String? uid, DateTime dateTime) async {
    return (await workProvider.getMonthlyWorkList(uid, dateTime)).snapshots().map(
            (snapshot) => snapshot.docs.map(
                (doc) => Work
                .fromJson(doc.data())
        ).toList()
    ).first;
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

