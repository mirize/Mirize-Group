import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldCustom {
  /// TextField для ввода номера телефона
  Widget textFieldPhone(
      TextEditingController controller,
      String hintText,
      bool textAlignCenter,
      bool autoFocus,
      bool enabled,
      bool error,
      bool successSendCode,
      FocusNode focusNode,
      Function onChanged(),
      Function onSubmitted()) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        prefixIconConstraints: BoxConstraints(maxHeight: 35, maxWidth: 45),
        prefixIcon: successSendCode
            ? Center(
                child: Container(
                  height: 15,
                  width: 15,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              )
            : error
                ? Center(
                    child: Icon(
                      Icons.error_outline_rounded,
                      color: Color.fromRGBO(255, 89, 100, 1),
                    ),
                  )
                : SizedBox(),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10.0),
        ),
        isCollapsed: true,
        hintText: hintText,
        contentPadding: EdgeInsets.symmetric(vertical: 13),
        filled: true,
        fillColor: error
            ? Color.fromRGBO(255, 89, 100, 0.1)
            : Color.fromRGBO(245, 245, 245, 1),
      ),
      textInputAction: TextInputAction.next,
      enabled: enabled,
      inputFormatters: [
        LengthLimitingTextInputFormatter(15),
      ],
      style: TextStyle(
          color: error
              ? Color.fromRGBO(255, 89, 100, 1)
              : Color.fromRGBO(13, 2, 33, 1)),
      autofocus: autoFocus,
      textAlign: textAlignCenter ? TextAlign.center : TextAlign.start,
      keyboardType: TextInputType.phone,
      onChanged: (value) {
        onChanged();
      },
      onSubmitted: onSubmitted(),
    );
  }

  Widget textFieldPhoneCode(
      TextEditingController controller,
      String hintText,
      bool textAlignCenter,
      bool autoFocus,
      bool enabled,
      Function onChanged()) {
    return TextField(
      controller: controller,
      scrollPadding: EdgeInsets.symmetric(horizontal: 10),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10.0),
        ),
        hintText: hintText,
        filled: false,
        fillColor: Color.fromRGBO(245, 245, 250, 1),
      ),
      textInputAction: TextInputAction.go,
      enabled: enabled,
      inputFormatters: [
        LengthLimitingTextInputFormatter(6),
      ],
      autofocus: autoFocus,
      textAlign: textAlignCenter ? TextAlign.center : TextAlign.start,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: TextInputType.phone,
      onChanged: (String value) {
        try {
          if (value.length == 6) {
            onChanged();
          }
        } catch (e) {}
      },
    );
  }

  Widget textField(
      TextEditingController controller,
      String hintText,
      bool textAlignCenter,
      bool autoFocus,
      bool error,
      Function onChanged(),
      Function onSubmitted()) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10.0),
        ),
        isCollapsed: true,
        hintText: hintText,
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        filled: true,
        fillColor: error
            ? Color.fromRGBO(255, 89, 100, 0.1)
            : Color.fromRGBO(247, 247, 247, 1),
      ),
      textInputAction: TextInputAction.next,
      inputFormatters: [
        LengthLimitingTextInputFormatter(15),
      ],
      style: TextStyle(
          color: error
              ? Color.fromRGBO(255, 89, 100, 1)
              : Color.fromRGBO(13, 2, 33, 1)),
      autofocus: autoFocus,
      textAlign: textAlignCenter ? TextAlign.center : TextAlign.start,
      keyboardType: TextInputType.text,
      onChanged: (value) {
        onChanged();
      },
      onSubmitted: onSubmitted(),
    );
  }

  Widget textFieldCommentedPost(
      TextEditingController controller,
      String hintText,
      bool textAlignCenter,
      bool autoFocus,
      bool enabled,
      bool error,
      Function onChanged(),
      Function onSubmitted()) {
    return TextField(
      controller: controller,
      maxLines: 2,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10.0),
        ),
        isCollapsed: true,
        hintText: hintText,
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        filled: true,
        fillColor: error
            ? Color.fromRGBO(255, 89, 100, 0.1)
            : Color.fromRGBO(245, 245, 245, 1),
      ),
      textInputAction: TextInputAction.next,
      enabled: enabled,
      style: TextStyle(
          color: error
              ? Color.fromRGBO(255, 89, 100, 1)
              : Color.fromRGBO(13, 2, 33, 1)),
      autofocus: autoFocus,
      textAlign: textAlignCenter ? TextAlign.center : TextAlign.start,
      keyboardType: TextInputType.text,
      onChanged: (value) {
        onChanged();
      },
      onSubmitted: onSubmitted(),
    );
  }
}
