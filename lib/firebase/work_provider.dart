import 'package:awesomethink/model/member.dart';
import 'package:awesomethink/model/work.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class WorkProvider with ChangeNotifier {
  Member? currentUser;
  Work? todayWork;
  Logger logger = Logger();

  WorkProvider(Member? user) {
    logger.d("init WorkProvider");
    currentUser = user;
  }

  Work? getTodayWork(){
    return todayWork;
  }

  void setTodayWork(Work? work){
    todayWork=work;
    notifyListeners();
  }


}