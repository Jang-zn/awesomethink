

import 'package:awesomethink/utils/constants.dart';

class Work{
  String? userUid; //User uid
  String? workUid;
  DateTime? startTime;
  DateTime? endTime;
  int? workingTimeState;
  DateTime? updateDate;


  Work({this.workUid,this.userUid, this.startTime, this.endTime, this.workingTimeState, this.updateDate});

  Work.fromJson(Map<String, dynamic> json){
    userUid=json['userUid'];
    workUid=json['workUid'];
    startTime=json['startTime'].toDate();
    endTime=json['endTime']?.toDate();
    workingTimeState=json['workingTimeState'];
    updateDate=json['updateDate'].toDate();
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['userUid']=userUid;
    data['workUid']=workUid;
    data['startTime']=startTime;
    data['endTime']=endTime;
    data['workingTimeState']=workingTimeState;
    data['updateDate']=updateDate;
    return data;
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
    String startMinute = startTime!.minute<10?"0"+startTime!.minute.toString():startTime!.minute.toString();
    String endHour = endTime==null?"":endTime!.hour.toString();
    String endMinute = endTime==null?"":endTime!.minute<10?"0"+endTime!.minute.toString():endTime!.minute.toString();
    String result = startHour+":"+startMinute+" ~ "+endHour+":"+endMinute;
    return result;
  }

  String workingTimeCalc(){
    String result="";
    Duration duration;
    if(endTime!=null){
     duration=endTime!.difference(startTime!);
     int total = duration.inMinutes;
     int h = (total-total%60)~/60;
     int m = total%60;
     String hour = h.toString();
     String minute = m>9?m.toString():"0"+m.toString();
     result = hour+"시간 "+minute+"분";
    }
    return result;
  }

  Work createWork(String uid) {
    Work work=Work();
    work.userUid = uid;
    work.startTime = DateTime.now();
    work.endTime = null;
    work.workingTimeState = WorkingTimeState.wait.index;
    work.updateDate = DateTime.now();
    return work;
  }


  @override
  String toString() {
    return 'Work{userUid: $userUid, workUid: $workUid, startTime: $startTime, endTime: $endTime, workingTimeState: $workingTimeState, updateDate: $updateDate}';
  }
}