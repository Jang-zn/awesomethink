

import 'package:awesomethink/utils/constants.dart';

class Work{
  String? uid;
  DateTime? startTime;
  DateTime? endTime;
  int? workingTimeState;
  DateTime? updateDate;


  Work({this.uid, this.startTime, this.endTime, this.workingTimeState, this.updateDate});

  Work.fromJson(Map<String, dynamic> json){
    uid=json['uid'];
    startTime=json['startTime'];
    endTime=json['endTime'];
    workingTimeState=json['workingTimeState'];
    updateDate=json['updateDate'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['uid']=uid;
    data['createTime']=startTime;
    data['endTime']=endTime;
    data['workingTimeState']=workingTimeState;
    data['updateDate']=updateDate;
    return data;
  }

  Work createWork(Map<String, String>workMap){
    Work work=Work();
    work.uid = workMap["uid"];
    work.startTime = DateTime.now();
    work.endTime = null;
    work.workingTimeState = WorkingTimeState.wait.index;
    work.updateDate = DateTime.now();
    return work;
  }

  String createTimeToMMDDW(){
    String month = startTime!.month.toString();
    String day = startTime!.day.toString();
    String week="";
    switch(startTime!.weekday){
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

  String workingTimeToHHMM(){
    String startHour = startTime!.hour.toString();
    String startMinute = startTime!.minute.toString();
    String endHour = endTime==null?"":endTime!.hour.toString();
    String endMinute = endTime==null?"":endTime!.minute.toString();
    String result = startHour+":"+startMinute+" ~ "+endHour+":"+endMinute;
    return result;
  }

  String workingTimeCalc(){
    String result="";
    Duration duration;
    if(endTime!=null){
     duration=endTime!.difference(startTime!);
     int total = duration.inMinutes;
     int h = (total-total%60)/60 as int;
     int m = total%60;
     String hour = h.toString();
     String minute = m>9?m.toString():"0"+m.toString();
     result = hour+"시간 "+minute+"분";
    }
    return result;
  }


}