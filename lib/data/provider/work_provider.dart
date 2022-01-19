import 'package:awesomethink/data/model/member.dart';
import 'package:awesomethink/data/model/work.dart';
import 'package:awesomethink/data/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class WorkProvider with ChangeNotifier {
  Member? currentUser;
  Work? currentWork;
  Logger logger = Logger();

  WorkProvider(Member? user) {
    currentUser = user;
    _prepareCurrentWork().then((_){
      logger.d("init WorkProvider : current"+currentWork.toString());
    });
  }

  Work? getCurrentWork(){
    return currentWork;
  }

  Future<bool?> getCurrentVacation() async {
    return await UserProvider().isVacationWait(currentUser?.uid);
  }

  Future<Work?> getCurrentTileWork(DateTime? startTime) async {
    return await UserProvider().getCurrentTileWork(startTime);
  }

  void setCurrentWork(Work? work){
    currentWork=work;
    notifyListeners();
  }

  Future<void> _prepareCurrentWork() async {
    currentWork=await UserProvider().getRecentWork(currentUser?.uid);
    notifyListeners();
  }


}