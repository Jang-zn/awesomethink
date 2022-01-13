

import 'package:awesomethink/model/work.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkValidation{

  bool checkInOut (DocumentSnapshot ds){
    if(ds["endTime"]==null) {
      return false;
    }else{
      return true;
    }
  }

}