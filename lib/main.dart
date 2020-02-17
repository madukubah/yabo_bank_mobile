import 'package:flutter/material.dart';
import 'activity/auth/login/LoginPage.dart';
import 'activity/auth/register/RegisterPage.dart';
import 'activity/profile/Profile.dart';
import 'activity/splash/SplashScreen.dart';
import 'activity/main/Home.dart';
import 'activity/ui/MainPage.dart';
import 'activity/ui/MapSample.dart';
import 'util/AppConstants.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SISA',
      theme: ThemeData(
        fontFamily: 'Ubuntu',
        // focusColor: AppColor.PRIMARY,
        // hoverColor: AppColor.PRIMARY,
        primarySwatch: Colors.deepOrange,
      ),
      // home: new MapSample(),
      home: new SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/Home': (BuildContext context) => new Home(  ) ,
        '/LoginPage': (BuildContext context) => new LoginPage(  ),
        '/RegisterPage': (BuildContext context) => new RegisterPage(  ),
        '/RegisterPage': (BuildContext context) => new RegisterPage(  ),
        '/Profile': (BuildContext context) => new Profile(  ),
        '/Main': (BuildContext context) => new MainPage(  ),
      },
      onGenerateRoute : (settings) {
        
      }
    );
  }
}
