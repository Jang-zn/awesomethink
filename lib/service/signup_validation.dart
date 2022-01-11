
import 'package:flutter/material.dart';

class SignUpValidation{
//TODO 이메일 양식 확인
  String? validateEmail(FocusNode focusNode, String? value){
    if(value!.isEmpty){
      focusNode.requestFocus();
      return '이메일을 입력하세요.';
    }else {
      RegExp regExp = RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
      if(!regExp.hasMatch(value)){
        focusNode.requestFocus();	//포커스를 해당 textformfield에 맞춘다.
        return '잘못된 이메일 형식입니다.';
      }else{
        return "";
      }
    }
  }
//TODO 비밀번호는 대충 자리수만 확인
bool passwordRule(String pw){
  if(pw.length<8){return false;}
  return true;
}

//TODO 비밀번호 체크랑 비밀번호랑 같은지 확인
bool passwordCheck(String pw, String check) {
  return pw == check;
}
//TODO 핸드폰번호 양식 확인

}
