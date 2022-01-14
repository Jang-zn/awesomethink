import 'package:awesomethink/firebase/user_database.dart';
import 'package:awesomethink/model/member.dart';
import 'package:awesomethink/model/work.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class WorkProvider with ChangeNotifier {
  Member? currentUser;
  Work? todayWork;
  Work? recentWork;
  Logger logger = Logger();

  WorkProvider(Member? user) {
    currentUser = user;
    user ?? _prepareRecentWork();
    logger.d("init WorkProvider");
  }

  Work? getTodayWork(){
    return todayWork;
  }

  Work? getRecentWork(){
    return recentWork;
  }

  void setTodayWork(Work? work){
    todayWork=work;
    notifyListeners();
  }

  void setRecentWork(Work? work){
    recentWork=work;
    notifyListeners();
  }

  void _prepareRecentWork() async {
    recentWork=await UserDatabase().getRecentWork(currentUser?.uid);
  }


}