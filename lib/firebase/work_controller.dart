import 'package:awesomethink/firebase/firebase_provider.dart';
import 'package:awesomethink/firebase/user_database.dart';
import 'package:awesomethink/model/member.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class WorkProvider with ChangeNotifier {
  Member? currentUser = FirebaseProvider().getUserInfo();
  bool? _workInOut;
  Logger logger = Logger();


  WorkProvider() {
    logger.d("init WorkProvider");
    _isWorkEnd();
  }


  _isWorkEnd() async {
    _workInOut=await UserDatabase().isWorkEnd(currentUser?.uid);
  }

  bool? getWorkInOut(){
    return _workInOut;
  }


}