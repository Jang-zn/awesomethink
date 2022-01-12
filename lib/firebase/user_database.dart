import 'package:awesomethink/model/member.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class UserDatabase{

  final CollectionReference userCollection = FirebaseFirestore.instance.collection("user");
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
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

  Member getUserByUid(String uid){
    Member userSnapshot = Member();
    firestore.collection("user").doc(uid).get().then(
        (DocumentSnapshot ds) {
          Member user = Member();
          user.uid= ds["uid"];
          user.email= ds["email"];
          user.name=ds["name"];
          user.position= ds["position"];
          user.phone=ds["phone"];
          user.joinedDate= ds["joinedDate"].toDate();
          user.retiredDate= ds["retiredDate"]?.toDate();
          user.type= ds["type"];
          user.state=ds["state"];
          userSnapshot=user;
      }
    );
    return userSnapshot;

  }


}