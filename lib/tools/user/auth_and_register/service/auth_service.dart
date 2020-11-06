import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mirize/windows/feed_screen.dart';
import 'package:mirize/windows/logged_screen.dart';
import 'package:mirize/windows/register_user_screen.dart';

class AuthService {
  bool isTrueAuthUser;

  handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (!snapshot.hasData) {
          // // DateTime lastTime =
          // //     FirebaseAuth.instance.currentUser.metadata.lastSignInTime;
          // // DateTime newLastTime = lastTime.add(new Duration(minutes: 30));
          // // DateTime createTime =
          // //     FirebaseAuth.instance.currentUser.metadata.creationTime;
          // // print(newLastTime);
          // // print(createTime);
          // // print(createTime.isAfter(newLastTime));
          // if (createTime.isAfter(newLastTime)) {
          //   return FeedScreen();
          // } else {
          //   return RegisterUser();
          // }
          return LoggedScreen();
        } else {
          return FeedScreen();
        }
      },
    );
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }

  signIn(AuthCredential authCredential) {
    FirebaseAuth.instance.signInWithCredential(authCredential);
  }
}
