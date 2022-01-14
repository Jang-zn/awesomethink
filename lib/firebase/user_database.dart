import 'package:awesomethink/model/member.dart';
import 'package:awesomethink/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class UserDatabase{

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference userCollection = firestore.collection("user");
  late Stream<QuerySnapshot> currentStream = firestore.collection("user").snapshots();

  storeUserData(Member user) async{
    DocumentReference documentReference = userCollection.doc(user.uid);

    var data = user.toJson();

    await documentReference.set(data).whenComplete(() {
      print("User data added");
    }).catchError((e)=>print(e));
  }

  Stream<QuerySnapshot> retrieveUsers(){
    Stream<QuerySnapshot> queryUsers = userCollection
        .orderBy('joinedDate', descending: true)
        .snapshots();

    return queryUsers;
  }

  Future<Member> getUserByUid (String uid) async {
    Member user = Member();
    await firestore.collection("user").doc(uid).get().then(
            (DocumentSnapshot ds){
          user.uid = ds["uid"];
          user.name = ds["name"];
          user.email = ds["email"];
          user.type = ds["type"];
          user.state = ds["state"];
          user.phone = ds["phone"];
          user.position = ds["position"];
          user.joinedDate = ds["joinedDate"]?.toDate();
          user.retiredDate = ds["retiredDate"]?.toDate();
        }
    );
    return user;
  }

  Stream<QuerySnapshot> getNewbieStream() {
    return firestore.collection("user").where("state",isEqualTo: false).snapshots();
  }


  Stream<QuerySnapshot> getWeeklyWorkStream(String uid) {
    //현재 기준으로 지난 일요일 날짜 구하기
    DateTime now = DateTime.now();
    DateTime lastSunday = DateTime(now.year, now.month, now.day - (now.weekday - 1));
    print(lastSunday.toString());
    return firestore.collection("work")
        .where("userUid",isEqualTo: uid)//User id에 해당하는 work들
        .where("startTime",isGreaterThanOrEqualTo: lastSunday)//중에서 일요일 기준으로 현재까지
        .snapshots();
  }


  //중복체크... List 길이 이용하면 되네
  Future<bool> checkDuplication(String userUid) async {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    int total=0;
    await firestore.collection('work')
             .where("userUid",isEqualTo: userUid)
             .where("startTime",isGreaterThanOrEqualTo: today)
             .get()
             .then((snapShot) {
        total = snapShot.docs.length;
    });
    return total==0?true:false;
  }


  //퇴근 안눌렀는지 체크
  Future<bool> isWorkEnd(String? workUid) async {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    int total=0;
    await firestore.collection('work')
        .where("workUid",isEqualTo: workUid)
        .where("workingTimeState",isEqualTo: WorkingTimeState.wait.index)
        .get()
        .then((snapShot) {
      total = snapShot.docs.length;
    });
    return total==0?true:false;

  }

}