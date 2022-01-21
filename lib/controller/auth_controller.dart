import 'package:awesomethink/data/provider/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class AuthController extends GetxController{
  final UserAuthProvider authProvider;
  Logger logger = Logger();
  User? _user; //FirebaseUser -> User 로 바뀜

  AuthController({required this.authProvider}){
    _prepareUser();
    logger.d("init UserAuthProvider"+_user.toString());
  }

  _prepareUser() {
    _user = authProvider.getCurrentUser();
  }

  //현재유저
  User? getCurrentUser() {
    return _user;
  }




  Future<bool?> signInWithEmail(String email, String password) async {
    bool? result = await authProvider.signInWithEmail(email, password).then(
            (value){
              if(value!) {
                _user = authProvider.getCurrentUser();
                update();
              }else{
                throw Exception("Sign Failed");
              }
            });
    return result;
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
    _user=null;
    authProvider.signOut();
    update();
  }
}