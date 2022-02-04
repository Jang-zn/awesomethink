class Vacation{
  DateTime? startVacation;
  DateTime? endVacation;

  Vacation({this.startVacation,this.endVacation});

  Vacation.fromJson(Map<String, dynamic> json){
    startVacation=json['startVacation']?.toDate();
    endVacation=json['endVacation']?.toDate();
  }


  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['startVacation']=startVacation;
    data['endVacation']=endVacation;
    return data;
  }

  @override
  String toString() {
    return 'Vacation{startVacation: $startVacation, endVacation: $endVacation}';
  }
}