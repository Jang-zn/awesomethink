import 'package:awesomethink/data/model/vacation.dart';
import 'package:awesomethink/utils/constants.dart';
import 'package:awesomethink/utils/time_format_converter.dart';

class Work{
  String? userUid; //User uid
  DateTime? startTime;
  DateTime? endTime;
  int? workingTimeState;
  DateTime? updateDate;
  Vacation? vacation;
  bool? checkOut;


  Work({this.userUid, this.startTime, this.endTime, this.workingTimeState, this.updateDate, this.vacation, this.checkOut});

  Work.fromJson(Map<String, dynamic> json){
    userUid=json['userUid'];
    startTime=json['startTime']?.toDate();
    endTime=json['endTime']?.toDate();
    workingTimeState=json['workingTimeState'];
    updateDate=json['updateDate']?.toDate();
    vacation = json['vacation']!=null?Vacation.fromJson(json['vacation']):null; //null체크 + fromJson으로 넣어주기
    checkOut=json['checkOut'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userUid']=userUid;
    data['startTime']=startTime;
    data['endTime']=endTime;
    data['workingTimeState']=workingTimeState;
    data['updateDate']=updateDate;
    data['vacation']=vacation?.toJson(); //toJson 한번 더 해야됨
    data['checkOut']=checkOut;
    return data;
  }

  String createTimeToMMDDW(){
    String month = startTime!.month.toString();
    String day = startTime!.day.toString();
    String week="";
    switch(startTime!.weekday){
      case 7:week="일";break;
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

  String getWorkingDay(){
    String result=startTime!.year.toString()+". ";
    result+= startTime!.month<10 ? "0"+startTime!.month.toString()+". " : startTime!.month.toString()+". ";
    result+=startTime!.day<10 ? "0"+startTime!.day.toString() : startTime!.day.toString();
    return result;
  }


  String workingTimeToHHMM(){
    String startHour = startTime!.hour<10?"0"+startTime!.hour.toString():startTime!.hour.toString();
    String startMinute = startTime!.minute<10?"0"+startTime!.minute.toString():startTime!.minute.toString();
    String endHour = endTime==null?"":endTime!.hour<10?"0"+endTime!.hour.toString():endTime!.hour.toString();
    String endMinute = endTime==null?"":endTime!.minute<10?"0"+endTime!.minute.toString():endTime!.minute.toString();
    String result = startHour+":"+startMinute+" ~ "+endHour+":"+endMinute;
    return result;
  }

  String workingTimeCalc(){
    String result="";
    Duration duration;
    if(endTime!=null){
      try {
        duration = endTime!.difference(startTime!);
      }catch(e){
        duration=startTime!.difference(startTime!);
      }
     int total = duration.inMinutes;

     //휴게시간 4시간마다 30분
     double checkTime = ((total-total%60)/240);
     //↑ 이거 int로 하면 1or2라서 분처리가 안됨
     if(checkTime>2){
       total-=60;
     }else if(checkTime>1){
       total-=30;
     }

     //시간계산
     int h = ((total-total%60)~/60);
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
    work.vacation = null;
    work.checkOut=false;
    return work;
  }

  //휴무는 하루가 아닐수 있으니 List로 처리
  List<Work> createVacation(String uid, DateTime start, DateTime end){
    List<Work> vacationList=[];
    int count = end.day-start.day+1;
    //count일간의 work 생성 (state=vacationWait)
    for(int i=0; i<count;i++) {
      Work vacation = Work();
      vacation.userUid = uid;
      //정상근무처리
      vacation.startTime = DateTime(start.year,start.month,start.day+i,9,0);
      vacation.endTime = DateTime(start.year,start.month,start.day+i,18,0);
      vacation.workingTimeState = WorkingTimeState.vacationWait.index;
      vacation.updateDate = DateTime.now();
      vacation.checkOut=true;
      vacation.vacation = Vacation(startVacation: start, endVacation: end);
      vacationList.add(vacation);
    }
    return vacationList;
  }

  //휴가 기간 String으로 변환
  //TODO 주말빼는법 연구.. 이거 하지 않았나?
  String getVacationPeriod(){
    List<DateTime> list = [];
    DateTime  newDate=vacation!.startVacation!;
    while(vacation!.endVacation!.difference(newDate).inDays>=0){
      if(newDate.weekday<=5) {
        list.add(newDate);
      }
      newDate = DateTime(newDate.year,newDate.month,newDate.day+1);
    }
    return "${TimeFormatConverter.dateTimeToMMDDW(vacation!.startVacation!)}"
        " ~ "
        "${TimeFormatConverter.dateTimeToMMDDW(vacation!.endVacation!)} : ${list.length}일";
  }



  @override
  String toString() {
    return 'Work{userUid: $userUid, startTime: $startTime, endTime: $endTime, workingTimeState: $workingTimeState, updateDate: $updateDate, vacation: ${vacation.toString()}}';
  }

  Map<String, int> getWorkingTimeToMap(){
    Map<String, int> timeMap={};
    Duration duration;
    try {
      duration = endTime!.difference(startTime!);
    }catch(e){
      duration = startTime!.difference(startTime!);
    }
      int total = duration.inMinutes;

      //휴게시간 4시간마다 30분
      double checkTime = ((total - total % 60) / 240);
      //↑ 이거 int로 하면 1or2라서 분처리가 안됨
      if (checkTime > 2) {
        total -= 60;
      } else if (checkTime > 1) {
        total -= 30;
      }

      int h = (total - total % 60) ~/ 60;
      int m = total % 60;
      timeMap.putIfAbsent("hour", () => h);
      timeMap.putIfAbsent("minute", () => m);
      return timeMap;

  }


}