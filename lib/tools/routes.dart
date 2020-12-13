import 'package:flutter/material.dart';
import 'package:mirize/page/auth_user/register_page.dart';
import 'package:mirize/page/home.dart';
import 'package:mirize/splash.dart';
import 'package:mirize/tools/custom_routes.dart';

class Routes{
  static dynamic route(){
      return {
          'SplashPage': (BuildContext context) =>   SplashPage(),
      };
  }

  static void sendNavigationEventToFirebase(String path) {
    if(path != null && path.isNotEmpty){
      // analytics.setCurrentScreen(screenName: path);
    }
  }

  static Route onGenerateRoute(RouteSettings settings) {
     final List<String> pathElements = settings.name.split('/');
     if (pathElements[0] != '' || pathElements.length == 1) {
       return null;
     }
     switch (pathElements[1]) {
      case "RegisterPage":return CustomRoute<bool>(builder:(BuildContext context)=> RegisterPage());
      case "ConfirmCode":return CustomRoute<bool>(builder:(BuildContext context)=> RegisterPage());
      case "HomePage":return CustomRoute<bool>(builder:(BuildContext context)=> HomePage());
     }
  }
}