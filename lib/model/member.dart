

class Member{

  String? memberId;
  int? memberNo;
  String? memberPw;
  String? name;
  String? position;
  String? email;
  String? phone;
  int? type;
  bool? state;
  DateTime? joinedDate;
  DateTime? retiredDate;

  Member(
      this.memberId,
      this.memberNo,
      this.memberPw,
      this.name,
      this.position,
      this.email,
      this.phone,
      this.type,
      this.state,
      this.joinedDate,
      this.retiredDate);
}