import 'package:awesomethink/model/member.dart';
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

  Stream<QuerySnapshot>  getNewbieStream() {
    return firestore.collection("user").where("state",isEqualTo: false).snapshots();
  }
}