import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mirize/tools/enum.dart';
import 'package:mirize/tools/state/app_state.dart';
import 'package:uuid/uuid.dart';

class CloudFirestore extends AppState {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  ConfirmationResult confirmationResult;
  User user;

  /// Вход по номеру телефона v.1
  signInWithCredential(authResult, context) async {
    UserCredential firebaseResult =
        await FirebaseAuth.instance.signInWithCredential(authResult);
    user = firebaseResult.user;
    if (firebaseResult.additionalUserInfo.isNewUser) {
      authStatus = AuthStatus.REGISTER_NOW_USER;
      Navigator.pushNamed(context, "/RegisterPage");
    } else {
      authStatus = AuthStatus.LOGGED_IN;
      Navigator.pushNamed(context, "/HomePage");
    }
  }

  signInWithPhoneNumberWeb(phoneNumber) async {
    confirmationResult = await FirebaseAuth.instance.signInWithPhoneNumber(
      phoneNumber,
    );
  }

  signInWithPhoneNumberWebConfirm(code, context) async {
    UserCredential userCredential = await confirmationResult.confirm(code);
    user = userCredential.user;
    if (userCredential.additionalUserInfo.isNewUser) {
      authStatus = AuthStatus.REGISTER_NOW_USER;
      Navigator.pushNamed(context, "/RegisterPage");
    } else {
      authStatus = AuthStatus.LOGGED_IN;
      Navigator.pushNamed(context, "/HomePage");
    }
  }

  /// Вход по номеру телефона v.2
  signInWithCredentialOTP(smsCODE, verID, context) {
    AuthCredential authCredential =
        PhoneAuthProvider.credential(verificationId: verID, smsCode: smsCODE);
    signInWithCredential(authCredential, context);
  }

  Future<User> getCurrentUser() async {
    try {
      loading = true;
      user = _firebaseAuth.currentUser;
      if (user != null) {
        authStatus = AuthStatus.LOGGED_IN;
      } else {
        authStatus = AuthStatus.NOT_LOGGED_IN;
      }
      loading = false;
      return user;
    } catch (error) {
      loading = false;
      debugPrint(user.toString());
      debugPrint("ERROR");
      debugPrint(error.toString());
      authStatus = AuthStatus.NOT_LOGGED_IN;
      return null;
    }
  }

  Future<void> createNewUser(
    String username,
    String downloadURI,
    double latitude,
    double longitude,
  ) async {
    await Firebase.initializeApp();
    String uid = FirebaseAuth.instance.currentUser.uid;
    var phone = FirebaseAuth.instance.currentUser.phoneNumber;
    CollectionReference ref = FirebaseFirestore.instance.collection("users");
    ref.doc(uid).set({
      "username": username,
      "uriImage": downloadURI,
      "latitude": latitude,
      "longitude": longitude,
      "phoneNumber": phone,
    });
    return;
  }

  Future<void> createdComment(
    BuildContext context,
    String textComment,
    String fromUserUID,
    String uidPost,
  ) async {
    await Firebase.initializeApp();
    String randomName;
    randomName = Uuid().v4();
    String uid = FirebaseAuth.instance.currentUser.uid;
    CollectionReference ref = FirebaseFirestore.instance.collection("posts");
    ref.doc(uidPost).collection("comment").doc(randomName).set({
      "uidPost": uidPost,
      "uidComment": randomName,
      "textComment": textComment,
      "fromUserUID": uid,
      "timeCreated": DateTime.now().toUtc().toString(),
    });
    return;
  }

  Future<void> createNewPost(
    BuildContext context,
    String imagePath,
    String textPost,
    String timeCreate,
  ) async {
    await Firebase.initializeApp();
    String randomName;
    randomName = Uuid().v4();
    String uid = FirebaseAuth.instance.currentUser.uid;
    CollectionReference ref = FirebaseFirestore.instance.collection("posts");
    ref.doc(randomName).set({
      "uidUser": uid,
      "imagePath": imagePath,
      "textPost": textPost,
      "timeCreate": timeCreate,
      "idPost": randomName,
    });
    CollectionReference refUser =
        FirebaseFirestore.instance.collection("users");
    refUser.doc(uid).collection("post").doc(randomName).set({
      "postId": randomName,
      "timeCreate": timeCreate,
    }).whenComplete(() => Navigator.pushNamed(context, "/HomePage"));
    return;
  }

  Future<void> getUserFromUid(uid) async {
    await Firebase.initializeApp();
    FirebaseFirestore.instance
        .collection("users")
        .where(uid, isEqualTo: uid)
        .get()
        .then((snapshot) {
      if (snapshot != null) {
        snapshot.docs.forEach((element) {
          print(element.data);
          return element.data;
        });
      } else {
        print("No data found");
      }
    });
    return;
  }

  Future<void> read(collection, name, [isEqualTos]) async {
    await Firebase.initializeApp();

    FirebaseFirestore.instance
        .collection(collection)
        .where(name, isEqualTo: isEqualTos)
        .get()
        .then((snapshot) {
      if (snapshot != null) {
        snapshot.docs.forEach((element) {
          print(element.id);
          print(element.data().toString());
        });
      } else {
        print("No data found");
      }
    });
    return;
  }

  Future<void> update() async {
    await Firebase.initializeApp();
    CollectionReference ref = FirebaseFirestore.instance.collection('Users');
    ref
        .doc('1234')
        .update({"name": "test1"})
        .then((value) => print("Success"))
        .catchError((error) => print(error.toString()));
    return;
  }

  Future<void> delete() async {
    await Firebase.initializeApp();
    CollectionReference ref = FirebaseFirestore.instance.collection('Users');
    ref
        .doc('9123')
        .delete()
        .then((value) => print("Success"))
        .catchError((error) => print(error.toString()));
    return;
  }
}
