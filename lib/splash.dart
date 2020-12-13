import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mirize/page/auth_user/login_page.dart';
import 'package:mirize/page/auth_user/register_page.dart';
import 'package:mirize/page/home.dart';
import 'package:mirize/tools/enum.dart';
import 'package:mirize/tools/state/database.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      timer();
    });
    super.initState();
  }

  void timer() async {
    Future.delayed(Duration(seconds: 1)).then((_) {
      var state = Provider.of<CloudFirestore>(context, listen: false);
      state.getCurrentUser();
    });
  }

  Widget _body() {
    var height = 85.0;
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Container(
          height: height,
          width: height,
          alignment: Alignment.center,
          child: Image.asset(
            'assets/images/rounted/rounted_icon_100.png',
            height: height,
            width: height,
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<CloudFirestore>(context);
    print(state.authStatus);
    return Scaffold(
      body: state.authStatus == AuthStatus.NOT_DETERMINED
          ? _body()
          : state.authStatus == AuthStatus.LOGGED_IN
              ? HomePage()
              : state.authStatus == AuthStatus.NOT_LOGGED_IN ||
                      state.authStatus != AuthStatus.LOGGED_IN
                  ? LoginPage(loginCallback: state.getCurrentUser)
                  : state.authStatus == AuthStatus.REGISTER_NOW_USER ||
                          state.authStatus != AuthStatus.LOGGED_IN
                      ? RegisterPage()
                      : HomePage(),
    );
  }
}
