import 'package:awesomethink/data/provider/contant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

class UserAuthProvider {
  Logger logger = Logger();
  final FirebaseAuth fAuth = FirebaseAuth.instance; //provider 인증 인스턴스
  final FirebaseFirestore firestore = ProviderConstance.firestore;//firestore 인스턴스


  User? getCurrentUser(){
    return fAuth.currentUser;
  }


  Future<UserCredential> signUpWithEmail(String email, String password) async {
    return await fAuth.createUserWithEmailAndPassword(email: email, password: password);
  }


  // 이메일/비밀번호로 Firebase에 로그인
  Future<UserCredential> signInWithEmail(String email, String password) async {
    return await fAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  // Firebase로부터 로그아웃
  void signOut() async {
    await fAuth.signOut();
  }


  //TODO
  // // 사용자에게 비밀번호 재설정 메일을 한글로 전송 시도
  // sendPasswordResetEmailByKorean() async {
  //   await fAuth.setLanguageCode("ko");
  //   sendPasswordResetEmail();
  // }
  //
  // // 사용자에게 비밀번호 재설정 메일을 전송
  // sendPasswordResetEmail() async {
  //   var sendPasswordResetEmail = fAuth.sendPasswordResetEmail(
  //       email: getUser().email);
  // }
}