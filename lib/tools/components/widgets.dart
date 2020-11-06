import 'package:flutter/material.dart';
import 'package:mirize/app_localizations.dart';
import 'package:mirize/main.dart';

class WidgetsMirizeGroup {
  Widget langInit(context) {
    Locale myLocale = Localizations.localeOf(context);
    print(myLocale.countryCode);
    if (myLocale.countryCode == "RU") {
      return Text(AppLocalizations.of(context).translate('lang_ru'),
          style: TextStyle(
              fontFamily: "Nunito",
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white));
    } else if (myLocale.countryCode == "US") {
      return Text(AppLocalizations.of(context).translate('lang_us'),
          style: TextStyle(
              fontFamily: "Nunito",
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white));
    } else if (myLocale.countryCode == "UK") {
      return Text(AppLocalizations.of(context).translate('lang_uk'),
          style: TextStyle(
              fontFamily: "Nunito",
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white));
    } else if (myLocale.countryCode == "AR") {
      return Text(AppLocalizations.of(context).translate('lang_ar'),
          style: TextStyle(
              fontFamily: "Nunito",
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white));
    } else if (myLocale.countryCode == "BN") {
      return Text(AppLocalizations.of(context).translate('lang_bn'),
          style: TextStyle(
              fontFamily: "Nunito",
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white));
    } else if (myLocale.countryCode == "ES") {
      return Text(AppLocalizations.of(context).translate('lang_es'),
          style: TextStyle(
              fontFamily: "Nunito",
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white));
    } else if (myLocale.countryCode == "HI") {
      return Text(AppLocalizations.of(context).translate('lang_hi'),
          style: TextStyle(
              fontFamily: "Nunito",
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white));
    } else if (myLocale.countryCode == "PT") {
      return Text(AppLocalizations.of(context).translate('lang_pt'),
          style: TextStyle(
              fontFamily: "Nunito",
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white));
    } else if (myLocale.countryCode == "RO") {
      return Text(AppLocalizations.of(context).translate('lang_ro'),
          style: TextStyle(
              fontFamily: "Nunito",
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white));
    } else if (myLocale.countryCode == "ZH") {
      return Text(AppLocalizations.of(context).translate('lang_zh'),
          style: TextStyle(
              fontFamily: "Nunito",
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white));
    } else if (myLocale.countryCode == "FR") {
      return Text(AppLocalizations.of(context).translate('lang_fr'),
          style: TextStyle(
              fontFamily: "Nunito",
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white));
    } else if (myLocale.countryCode == "DE") {
      return Text(AppLocalizations.of(context).translate('lang_de'),
          style: TextStyle(
              fontFamily: "Nunito",
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white));
    } else if (myLocale.countryCode == "IT") {
      return Text(AppLocalizations.of(context).translate('lang_it'),
          style: TextStyle(
              fontFamily: "Nunito",
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white));
    } else if (myLocale.countryCode == "JA") {
      return Text(AppLocalizations.of(context).translate('lang_ja'),
          style: TextStyle(
              fontFamily: "Nunito",
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white));
    }
  }
}
