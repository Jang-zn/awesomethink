import 'package:awesomethink/data/provider/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class AuthController extends GetxController{
  final UserAuthProvider authProvider = UserAuthProvider();
  Logger logger = Logger();

  final Rxn<User?> _user =  Rxn<User?>(); //FirebaseUser -> User 로 바뀜

  AuthController(){
    _prepareUser();
    logger.d("init UserAuthProvider"+_user.toString());
  }

  _prepareUser() {
    _user.value = authProvider.getCurrentUser();
  }

  //현재유저
  User? getCurrentUser() {
    return _user.value;
  }

  Future<void> signInWithEmail(String email, String password) async {
    _user.value = (await authProvider.signInWithEmail(email, password)).user;
  }

  void signUpWithEmail(String email, String password) async {
    bool? result = await authProvider.signUpWithEmail(email, password).then((value){
      if (value!) {
        // 새로운 계정 생성이 성공하였으므로 기존 계정이 있을 경우 로그아웃 시킴
        signOut();
      }else{
        throw Exception("Sign Failed");
      }
    });
  }


  void signOut() {
    _user(null);
    authProvider.signOut();
  }
}