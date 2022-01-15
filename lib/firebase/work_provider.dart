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
    _prepareRecentWork().then((_){
      logger.d("init WorkProvider : "+recentWork.toString());
    });
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

  Future<void> setRecentWork(Member? user) async {
    user ?? _prepareRecentWork();
    notifyListeners();
  }

  Future<void> _prepareRecentWork() async {
    recentWork=await UserDatabase().getRecentWork(currentUser?.uid);
    notifyListeners();
  }


}