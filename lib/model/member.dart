

import 'package:awesomethink/utils/constants.dart';
import 'package:flutter/widgets.dart';

class Member{
  String? uid;
  String? email;
  String? name;
  String? position;
  String? phone;
  int? type;
  bool? state;
  DateTime? joinedDate;
  DateTime? retiredDate;

  Member({
      this.uid,
      this.name,
      this.position,
      this.email,
      this.phone,
      this.type,
      this.state,
      this.joinedDate,
      this.retiredDate});

  Member.fromJson(Map<String, dynamic> json){
    uid=json['uid'];
    name=json['name'];
    position=json['position'];
    email=json['email'];
    phone=json['phone'];
    type=json['type'];
    state=json['state'];
    joinedDate=json['joinedDate'];
    retiredDate=json['retiredDate'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['uid']=this.uid;
    data['name']=this.name;
    data['position']=this.position;
    data['email']=this.email;
    data['phone']=this.phone;
    data['type']=this.type;
    data['state']=this.state;
    data['joinedDate']=this.joinedDate;
    data['retiredDate']=this.retiredDate;

    return data;
  }

  Member userSignUpData(Map<String, String>userMap){
    Member user=Member();
    user.uid = userMap["uid"];
    user.name = userMap["name"];
    user.position = userMap["position"];
    user.email = userMap["email"];
    user.type = UserType.normal.index;
    user.phone = userMap["phone"];
    user.state = false;
    user.joinedDate = DateTime.now();
    user.retiredDate = null;
    return user;
  }

  @override
  String toString() {
    return 'Member{uid: $uid, email: $email, name: $name, position: $position, phone: $phone, type: $type, state: $state, joinedDate: $joinedDate, retiredDate: $retiredDate}';
  }
}