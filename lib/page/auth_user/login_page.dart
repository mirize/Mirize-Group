import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mirize/tools/state/database.dart';
import 'package:mirize/widgets/flatButtonCustom.dart';
import 'package:mirize/widgets/textFieldCustom.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback loginCallback;
  LoginPage({Key key, this.loginCallback}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String verificationID;
  TextEditingController _phoneAuth;
  TextEditingController _codeAuth;
  bool enabled = true;
  bool error = false;
  bool waiting = false;
  bool sendCode = false;
  FocusNode phoneFocusNode;
  Duration timeoutVerifyPhone = const Duration(seconds: 5);

  String errorAuth;

  @override
  void initState() {
    _phoneAuth = TextEditingController();
    _codeAuth = TextEditingController();
    phoneFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _phoneAuth.dispose();
    _codeAuth.dispose();
    phoneFocusNode.dispose();
    super.dispose();
  }

  Widget codeSendModalBottomSheet(context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        top: Radius.circular(35),
      )),
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      builder: (context) {
        return NotificationListener<DraggableScrollableNotification>(
          child: DraggableScrollableActuator(
            child: DraggableScrollableSheet(
              minChildSize: 0.3,
              initialChildSize: 0.55,
              maxChildSize: 1.0,
              expand: false,
              builder: (context, controller) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(35),
                    ),
                  ),
                  child: SingleChildScrollView(
                    controller: controller,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10, bottom: 20),
                          width: 75,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(0, 106, 255, 0.4),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 5,
                        ),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Подтверждение",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(0, 106, 255, 1)),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text(
                            "Введите смс код из сообщения, который был отправлен на ваш телефон",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                        ),
                        TextFieldCustom().textFieldPhoneCode(
                            _codeAuth, "Введите код", true, false, true, () {
                          setState(() {
                            enabled = true;
                          });
                          var state = Provider.of<CloudFirestore>(context,
                              listen: false);
                          state.signInWithCredentialOTP(
                              _codeAuth.text, verificationID, context);
                        }),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: GestureDetector(
              onTap: () {
                codeSendModalBottomSheet(context);
              },
              child: Container(
                margin: EdgeInsets.only(top: 45),
                width: double.infinity,
                child: Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/rounted/rounted_icon_100.png",
                          height: 35,
                          width: 35,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          child: Text(
                            "connect",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          sendCode
              ? SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.only(top: 175, left: 30, right: 30),
                    width: double.infinity,
                    child: Center(
                      child: TextFieldCustom().textFieldPhone(
                          _codeAuth,
                          "Введите код подтверждения",
                          true,
                          true,
                          enabled,
                          error,
                          waiting,
                          phoneFocusNode, () {
                        setState(() {
                          waiting = false;
                          error = false;
                        });
                      }, () {}),
                    ),
                  ),
                )
              : SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.only(top: 175, left: 30, right: 30),
                    width: double.infinity,
                    child: Center(
                      child: TextFieldCustom().textFieldPhone(
                          _phoneAuth,
                          "Введите номер телефона",
                          true,
                          true,
                          enabled,
                          error,
                          waiting,
                          phoneFocusNode, () {
                        setState(() {
                          waiting = false;
                          error = false;
                        });
                      }, () {}),
                    ),
                  ),
                ),
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              height: 40,
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: FlatButtonCustom().flatButtonPhone(() async {
                if (!sendCode) {
                  setState(() {
                    if (kIsWeb) {
                      enabled = true;
                    } else {
                      enabled = false;
                    }
                    error = false;
                    waiting = false;
                  });
                  if (_phoneAuth.text == "") {
                    setState(() {
                      waiting = false;
                      error = true;
                      enabled = !enabled;
                    });
                  } else {
                    verifyPhone(_phoneAuth.text, context);
                  }
                } else {
                  var state =
                      Provider.of<CloudFirestore>(context, listen: false);
                  if (kIsWeb) {
                    state.signInWithPhoneNumberWebConfirm(
                        _codeAuth.text, context);
                  } else {
                    state.signInWithCredentialOTP(
                        _codeAuth.text, verificationID, context);
                  }
                }
              }),
            ),
          ),
        ],
      ),
    );
  }

  /// Авторизация и регистрация пользователя, по его номеру телефона
  Future<void> verifyPhone(phoneNumber, context) async {
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential authResult) {
      var state = Provider.of<CloudFirestore>(context, listen: false);
      state.signInWithCredential(authResult, context);
      widget.loginCallback();
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      if (authException.code == 'invalid-phone-number') {
        errorAuth = "Вы ввели неверный номер телефона";
      } else if (authException.code == "") {
        errorAuth = "";
      }
      // Ошибка авторизации
      setState(() {
        error = true;
        waiting = false;
        enabled = true;
      });
      print(authException.code);
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationID = verId;
      setState(() {
        error = false;
        waiting = true;
        enabled = false;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout = (String verId) {
      this.verificationID = verId;

      codeSendModalBottomSheet(context);
    };

    if (kIsWeb) {
      var state = Provider.of<CloudFirestore>(context, listen: false);
      state.signInWithPhoneNumberWeb(phoneNumber);
      setState(() {
        sendCode = true;
      });
    } else {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: verificationCompleted,
          timeout: const Duration(seconds: 5),
          verificationFailed: verificationFailed,
          codeSent: smsSent,
          codeAutoRetrievalTimeout: autoRetrievalTimeout);
    }
  }
}
