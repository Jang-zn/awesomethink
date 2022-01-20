
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

  void setWeeklyWorkList() async {
    weeklyWorkList = await workProvider.getWeeklyWorkList(userInfo.uid);
  }

  void setMonthlyWorkList(DateTime dateTime) async {
    weeklyWorkList = await workProvider.getMonthlyWorkList(userInfo.uid, dateTime);
  }

  List<Work?>? getWeeklyWorkList(){
    return weeklyWorkList;
  }

  List<Work?>? getMonthlyWorkList(){
    return monthlyWorkList;
  }


}

