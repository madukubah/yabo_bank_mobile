import 'package:flutter/material.dart';

class AppConstants 
{
  static const LOGIN_FAILURE = 1004;
  static const NULL_INDEX = -1;
  static const APP_NAME = "SISA";
}

 enum LoggedInMode {
  LOGGED_IN_MODE_LOGGED_OUT,
  LOGGED_IN_MODE_GOOGLE,
  LOGGED_IN_MODE_FB,
  LOGGED_IN_MODE_SERVER
}

class AppColor{
  static const Color PRIMARY_DARK = Color.fromARGB(255, 213, 82, 9); //3
  static const Color PRIMARY = Color.fromARGB(255, 226, 116, 41); //2
  static const Color SECONDARY = Colors.blueAccent;
}