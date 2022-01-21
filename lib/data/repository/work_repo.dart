
import 'package:awesomethink/data/model/member.dart';
import 'package:awesomethink/data/model/work.dart';
import 'package:awesomethink/data/provider/work_provider.dart';
import 'package:logger/logger.dart';

class WorkRepository{
  Member userInfo;
  List<Work?>? monthlyWorkList;
  List<Work?>? weeklyWorkList;
  final WorkProvider workProvider;
  Logger logger = Logger();

  WorkRepository({required this.workProvider, required this.userInfo}){
    setWeeklyWorkList();
    setMonthlyWorkList(DateTime.now());
    logger.d("init WorkRepository : "+userInfo.name!);
  }

  void setWeeklyWorkList() {
    workProvider.getWeeklyWorkList(userInfo.uid).then((value)=>weeklyWorkList = value);
  }

  void setMonthlyWorkList(DateTime dateTime) {
    workProvider.getMonthlyWorkList(userInfo.uid, dateTime).then((value) => monthlyWorkList = value);
  }

  List<Work?>? getWeeklyWorkList(){
    return weeklyWorkList;
  }

  List<Work?>? getMonthlyWorkList(){
    return monthlyWorkList;
  }

  bool updateWorkingTimeState(Work? work, int state){
    return workProvider.updateWorkingTimeState(work, state);
  }

  Future<bool?> setWork(Work? work) async{
    return await workProvider.setWork(work);
  }

  Future<bool?> updateWork(Work? work) async{
    return await workProvider.updateWork(work);
  }

}

