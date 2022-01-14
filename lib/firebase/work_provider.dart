import 'package:awesomethink/firebase/user_database.dart';
import 'package:awesomethink/model/member.dart';
import 'package:awesomethink/model/work.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class WorkProvider with ChangeNotifier {
  Member? currentUser;
  Work? todayWork;
  late bool _workEnd;
  Logger logger = Logger();

  WorkProvider(Member? user) {
    logger.d("init WorkProvider");
    currentUser = user;
    _isWorkEnd();
  }

  Future<void> _isWorkEnd() async {
    _workEnd=await UserDatabase().isWorkEnd(currentUser?.uid);
    notifyListeners();
  }

  bool? getWorkEnd(){
    return _workEnd;
  }

  void setWorkEnd(bool tof){
    _workEnd=tof;
    notifyListeners();
  }


}