import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mirize/app_localizations.dart';
import 'package:mirize/main.dart';
import 'package:mirize/service/auth_service.dart';
import 'package:mirize/windows/register_user_screen.dart';

class LoggedScreen extends StatefulWidget {
  @override
  _LoggedScreenState createState() => _LoggedScreenState();
}

class _LoggedScreenState extends State<LoggedScreen>
    with SingleTickerProviderStateMixin {
  final formKey = new GlobalKey<FormState>();
  String phoneNumber, verificationID, phoneCode;
  double _width = 50;
  double _height = 30;
  double _heightTwo = 0;
  double _widthTwo = 0;
  double _heightSubtitle = 25;
  double _heightTitle = 40;
  double _widthHint = 100;
  double _bottomMargin = 15;

  Duration _duration = Duration(milliseconds: 400);
  Duration _durationAppBar = Duration(milliseconds: 200);
  Duration _durationAppBarTwo = Duration(milliseconds: 200);
  Duration _durationHint = Duration(milliseconds: 400);
  Duration _durationSubtitle = Duration(milliseconds: 400);
  Duration _durationTitle = Duration(milliseconds: 400);

  bool isTrue = true;
  bool isVisible = false;
  bool isVisibleTwo = false;

  bool isEnable = true;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void validateVisible(String value) {
    if (value.length > 5 && value.isNotEmpty) {
      isVisible = true;
      isVisibleTwo = false;
    } else {
      isVisible = false;
      isVisibleTwo = true;
    }
  }

  Widget langModalBottomSheet(context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        top: Radius.circular(35),
      )),
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      builder: (context) {
        return NotificationListener<DraggableScrollableNotification>(
          onNotification: (notification) {
            if (notification.extent >= 0.8) {
              setState(() {
                _heightSubtitle = 0;
                _heightTitle = 45;
                _widthHint = 0;
                _bottomMargin = 0;
              });
            } else if (notification.extent <= 0.77) {
              setState(() {
                _heightSubtitle = 25;
                _heightTitle = 40;
                _widthHint = 75;
                _bottomMargin = 15;
              });
            }
          },
          child: DraggableScrollableActuator(
            child: DraggableScrollableSheet(
              minChildSize: 0.3,
              initialChildSize: 0.5,
              maxChildSize: 0.8,
              expand: false,
              builder: (context, controller) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(35),
                    ),
                  ),
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: _durationHint,
                        width: _widthHint,
                        margin: EdgeInsets.only(
                            left: 30,
                            right: 30,
                            top: 20,
                            bottom: _bottomMargin),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(120, 150, 255, 0.4),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 5,
                        ),
                      ),
                      AnimatedContainer(
                        duration: _durationSubtitle,
                        height: _heightSubtitle,
                        child: Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            "Базовая настройка",
                            style: TextStyle(
                                fontFamily: "Nunito",
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        duration: _durationTitle,
                        height: _heightTitle,
                        child: Container(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            width: double.infinity,
                            child: Text("Установите стандартный язык",
                                style: TextStyle(
                                    fontFamily: "Nunito",
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(120, 150, 255, 1))),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: controller,
                          child: Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  Locale newLocale = Locale('ru', 'RU');
                                  MyHome.setLocale(context, newLocale);
                                  Navigator.pop(context);
                                },
                                title: Text(AppLocalizations.of(context)
                                    .translate('lang_ru')),
                              ),
                              ListTile(
                                onTap: () {
                                  Locale newLocale = Locale('en', 'US');
                                  MyHome.setLocale(context, newLocale);
                                  Navigator.pop(context);
                                },
                                title: Text(AppLocalizations.of(context)
                                    .translate('lang_us')),
                              ),
                              ListTile(
                                onTap: () {
                                  Locale newLocale = Locale('ar', 'AR');
                                  MyHome.setLocale(context, newLocale);
                                  Navigator.pop(context);
                                },
                                title: Text(AppLocalizations.of(context)
                                    .translate('lang_ar')),
                              ),
                              ListTile(
                                onTap: () {
                                  Locale newLocale = Locale('bn', 'BN');
                                  MyHome.setLocale(context, newLocale);
                                  Navigator.pop(context);
                                },
                                title: Text(AppLocalizations.of(context)
                                    .translate('lang_bn')),
                              ),
                              ListTile(
                                onTap: () {
                                  Locale newLocale = Locale('es', 'ES');
                                  MyHome.setLocale(context, newLocale);
                                  Navigator.pop(context);
                                },
                                title: Text(AppLocalizations.of(context)
                                    .translate('lang_es')),
                              ),
                              ListTile(
                                onTap: () {
                                  Locale newLocale = Locale('hi', 'HI');
                                  MyHome.setLocale(context, newLocale);
                                  Navigator.pop(context);
                                },
                                title: Text(AppLocalizations.of(context)
                                    .translate('lang_hi')),
                              ),
                              ListTile(
                                onTap: () {
                                  Locale newLocale = Locale('pt', 'PT');
                                  MyHome.setLocale(context, newLocale);
                                  Navigator.pop(context);
                                },
                                title: Text(AppLocalizations.of(context)
                                    .translate('lang_pt')),
                              ),
                              ListTile(
                                onTap: () {
                                  Locale newLocale = Locale('ro', 'RO');
                                  MyHome.setLocale(context, newLocale);
                                  Navigator.pop(context);
                                },
                                title: Text(AppLocalizations.of(context)
                                    .translate('lang_ro')),
                              ),
                              ListTile(
                                onTap: () {
                                  Locale newLocale = Locale('uk', 'UK');
                                  MyHome.setLocale(context, newLocale);
                                  Navigator.pop(context);
                                },
                                title: Text(AppLocalizations.of(context)
                                    .translate('lang_uk')),
                              ),
                              ListTile(
                                onTap: () {
                                  Locale newLocale = Locale('zh', 'ZH');
                                  MyHome.setLocale(context, newLocale);
                                  Navigator.pop(context);
                                },
                                title: Text(AppLocalizations.of(context)
                                    .translate('lang_zh')),
                              ),
                              ListTile(
                                onTap: () {
                                  Locale newLocale = Locale('fr', 'FR');
                                  MyHome.setLocale(context, newLocale);
                                  Navigator.pop(context);
                                },
                                title: Text(AppLocalizations.of(context)
                                    .translate('lang_fr')),
                              ),
                              ListTile(
                                onTap: () {
                                  Locale newLocale = Locale('de', 'DE');
                                  MyHome.setLocale(context, newLocale);
                                  Navigator.pop(context);
                                },
                                title: Text(AppLocalizations.of(context)
                                    .translate('lang_de')),
                              ),
                              ListTile(
                                onTap: () {
                                  Locale newLocale = Locale('it', 'IT');
                                  MyHome.setLocale(context, newLocale);
                                  Navigator.pop(context);
                                },
                                title: Text(AppLocalizations.of(context)
                                    .translate('lang_it')),
                              ),
                              ListTile(
                                onTap: () {
                                  Locale newLocale = Locale('ja', 'JA');
                                  MyHome.setLocale(context, newLocale);
                                  Navigator.pop(context);
                                },
                                title: Text(AppLocalizations.of(context)
                                    .translate('lang_ja')),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
      key: _scaffoldKey,
      appBar: AppBar(
        title: Column(
          children: [
            AnimatedContainer(
              height: _height,
              duration: _durationAppBar,
              curve: Curves.slowMiddle,
              child: Text(
                AppLocalizations.of(context).translate('enter_code_county'),
                style: TextStyle(
                  fontFamily: "Nunito",
                  fontSize: 20,
                  color: Colors.black87,
                ),
              ),
            ),
            AnimatedContainer(
              curve: Curves.slowMiddle,
              height: _heightTwo,
              duration: _durationAppBarTwo,
              child: Text(
                AppLocalizations.of(context).translate('your_phone'),
                style: TextStyle(
                  fontFamily: "Nunito",
                  fontSize: 20,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
        actions: [
          Visibility(
            visible: isVisibleTwo ? true : false,
            child: IconButton(
              onPressed: () {
                setState(() {
                  _height = 30;
                  _heightTwo = 0;
                  _width = 50;
                  _widthTwo = 0;
                  phoneCode = null;
                  phoneNumber = null;
                  isVisibleTwo = false;
                  isVisible = false;
                  isEnable = !isEnable;
                });
              },
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: Color.fromRGBO(120, 150, 255, 1),
              ),
            ),
          ),
        ],
        elevation: 1,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: double.infinity,
              child: Form(
                key: formKey,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: AnimatedContainer(
                          width: _width,
                          duration: _duration,
                          child: TextField(
                            autofocus: true,
                            enabled: isEnable,
                            textAlign: TextAlign.center,
                            cursorColor: Colors.black38,
                            onSubmitted: (val) {
                              FocusScope.of(context).nextFocus();
                              setState(() {
                                _widthTwo = 245;
                                _height = 0;
                                _heightTwo = 30;
                                phoneCode = val;
                                isVisibleTwo = true;
                                isEnable = !isEnable;
                              });
                            },
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            style:
                                TextStyle(fontSize: 16, fontFamily: "Nunito"),
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 10),
                              isCollapsed: true,
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Color.fromRGBO(120, 150, 255, 1),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        width: _widthTwo,
                        duration: _duration,
                        child: TextField(
                          cursorColor: Colors.black38,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) {
                            FocusScope.of(context).unfocus();
                            setState(() {
                              _widthTwo = 0;
                            });
                          },
                          style: TextStyle(fontSize: 16, fontFamily: "Nunito"),
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 10),
                              isCollapsed: true,
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Color.fromRGBO(120, 150, 255, 1),
                                ),
                              ),
                              hintText: AppLocalizations.of(context)
                                  .translate('enter_number')),
                          onChanged: (val) {
                            validateVisible(val);
                            setState(() {
                              this.phoneNumber = val;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
              child: Text(
                AppLocalizations.of(context).translate('confirm_text'),
                style: TextStyle(fontFamily: "Nunito", fontSize: 14),
              ),
            ),
            GestureDetector(
              onTap: () {
                langModalBottomSheet(context);
              },
              child: Container(
                height: 25,
                margin: EdgeInsets.only(top: 25),
                child: Center(
                  child: Text(
                      AppLocalizations.of(context).translate('selected_lang'),
                      style: TextStyle(
                          fontFamily: "Nunito",
                          fontSize: 15,
                          color: Colors.grey)),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Visibility(
        visible: isVisible ? true : false,
        child: FloatingActionButton(
          elevation: 0,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          backgroundColor: Color.fromRGBO(120, 150, 255, 1),
          child: isTrue
              ? Icon(Icons.arrow_forward)
              : CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 3,
                ),
          onPressed: () {
            verifyPhone(phoneNumber);
            setState(() {
              isTrue = !isTrue;
              isVisibleTwo = false;
            });
          },
        ),
      ),
    );
  }

  Future<void> verifyPhone(phoneNumber) async {
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential authResult) async {
      UserCredential firebaseResult =
          await FirebaseAuth.instance.signInWithCredential(authResult);
      if (firebaseResult.additionalUserInfo.isNewUser) {
        print("---------------------------");
        print(firebaseResult.additionalUserInfo.isNewUser);
        print("true");
        print("---------------------------");
        RegisterUser();
      } else {
        AuthService().signIn(authResult);
        print("---------------------------");
        print(firebaseResult.additionalUserInfo.isNewUser);
        print("---------------------------");
      }
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      print(authException);
      if (authException.code == 'network-request-failed') {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.fixed,
            backgroundColor: Color.fromRGBO(244, 67, 54, 1),
            content: Text('Предоставленный номер телефона недействителен'),
          ),
        );
        setState(() {
          isTrue = !isTrue;
        });
        print('The provided phone number is not valid.');
      } else if (authException.code == 'too-many-requests') {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.fixed,
            backgroundColor: Color.fromRGBO(244, 67, 54, 1),
            content: Text(
                'Мы заблокировали все запросы с этого устройства из-за необычной активности. Попробуйте позже.'),
          ),
        );
        setState(() {
          isTrue = !isTrue;
        });
      }
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationID = verId;
    };

    final PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout = (String verId) {
      this.verificationID = verId;
    };

    String fullPhone = phoneCode + phoneNumber;

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: fullPhone,
        verificationCompleted: verificationCompleted,
        timeout: const Duration(seconds: 5),
        verificationFailed: verificationFailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoRetrievalTimeout);
  }
}
