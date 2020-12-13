import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FlatButtonCustom {
  Widget flatButtonPhone(Future<void> on_pressed()) {
    return FlatButton(
      onPressed: () {
        on_pressed();
      },
      color: Color.fromRGBO(245, 245, 245, 1),
      shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.circular(10)),
      child: Container(alignment: Alignment.center, child: Text("Войти")),
    );
  }
}
