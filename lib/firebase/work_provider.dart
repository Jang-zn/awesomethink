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
      logger.d("init WorkProvider : current"+currentWork.toString());
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


}