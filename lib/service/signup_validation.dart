
import 'package:flutter/material.dart';

class SignUpValidation {

  String? validateEmail(FocusNode focusNode, String? value) {
    if (value!.isEmpty) {
      return '이메일을 입력하세요.';
    } else {
      RegExp regExp = RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
      if (!regExp.hasMatch(value)) {
        focusNode.requestFocus(); //포커스를 해당 textformfield에 맞춘다.
        return '잘못된 이메일 형식입니다.';
      } else {
        return null;
      }
    }
  }

  String? validateName(String? value) {
    if (value!.isEmpty || value.length < 2) {
      return '이름을 입력해주세요.';
    } else {
      return null;
    }
  }

  String? validatePassword(FocusNode focusNode, String? value) {
    if (value!.isEmpty) {
      return '비밀번호를 입력하세요.';
    } else {
      RegExp regExp = RegExp(
          r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?~^<>,.&+=])[A-Za-z\d$@$!%*#?~^<>,.&+=]{8,15}$');
      if (!regExp.hasMatch(value)) {
        focusNode.requestFocus();
        return '특수문자, 영문, 숫자 포함 8자 이상 15자 이내로 입력하세요.';
      } else {
        return null;
      }
    }
  }

  String? validatePasswordCheck(FocusNode focusNode, String? pw,
      String? value) {
    if (pw != value) {
      return "비밀번호가 일치하지 않습니다.";
    } else {
      return null;
    }
  }

//TODO 핸드폰번호 양식 확인
  String? validatePhoneNumber(String? value) {
    if (value!.isEmpty||value.length<11) {
      return '전화번호를 입력하세요. \'-\' 포함';
    } else {
      RegExp regExp = RegExp(
          r'^\d{3}-\d{3,4}-\d{4}$');
      if (!regExp.hasMatch(value)) {
        return '잘못된 전화번호 형식입니다.';
      } else {
        return null;
      }
    }
  }

}