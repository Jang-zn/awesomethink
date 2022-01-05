
import 'package:flutter/material.dart';

class TimeFormatConverter{

  static String dateTimeToMMDDW(DateTime dateTime){
    String month = dateTime.month.toString();
    String day = dateTime.day.toString();
    String week="";
    switch(dateTime.weekday){
      case 0:week="일";break;
      case 1:week="월";break;
      case 2:week="화";break;
      case 3:week="수";break;
      case 4:week="목";break;
      case 5:week="금";break;
      case 6:week="토";break;
    }

    String result = month+"/"+day+" ("+week+")";
    return result;
  }

  static String dateTimeToHHMM(DateTime dateTime){
    String hour = dateTime.hour.toString();
    String minute = dateTime.minute.toString();
    String result = hour+":"+minute;
    return result;
  }
}