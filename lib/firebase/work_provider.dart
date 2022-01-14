import 'package:awesomethink/firebase/firebase_provider.dart';
import 'package:awesomethink/firebase/user_database.dart';
import 'package:awesomethink/model/member.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class WorkProvider with ChangeNotifier {
  Member? currentUser = FirebaseProvider().getUserInfo();
  late bool _workEnd;
  Logger logger = Logger();

  WorkProvider() {
    _isWorkEnd();
  }

  Future<void> _isWorkEnd() async {
    _workEnd=await UserDatabase().isWorkEnd(currentUser?.uid);
    logger.d("init WorkProvider");
    notifyListeners();
  }

  bool? getWorkInOut(){
    return _workEnd;
  }


}