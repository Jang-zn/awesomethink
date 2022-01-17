import 'package:awesomethink/firebase/user_database.dart';
import 'package:awesomethink/model/member.dart';
import 'package:awesomethink/model/work.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class WorkProvider with ChangeNotifier {
  Member? currentUser;
  Work? currentWork;
  Logger logger = Logger();

  WorkProvider(Member? user) {
    currentUser = user;
    _prepareCurrentWork().then((_){
      logger.d("init WorkProvider : "+currentWork.toString());
    });
  }

  Work? getCurrentWork(){
    return currentWork;
  }

  Future<bool?> getCurrentVacation() async {
    return await UserDatabase().isVacationWait(currentUser?.uid);
  }

  void setCurrentWork(Work? work){
    currentWork=work;
    notifyListeners();
  }

  Future<void> _prepareCurrentWork() async {
    currentWork=await UserDatabase().getRecentWork(currentUser?.uid);
    notifyListeners();
  }

  //TODO 휴무관련해서 currentWork setting하는 조건 설정 필요할듯


}