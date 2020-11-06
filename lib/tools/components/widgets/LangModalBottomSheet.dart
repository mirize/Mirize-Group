import 'package:flutter/material.dart';
import 'package:mirize/app_localizations.dart';
import 'package:mirize/main.dart';

class LangModalBottomSheet extends StatefulWidget {
  LangModalBottomSheet({Key key}) : super(key: key);

  @override
  _LangModalBottomSheetState createState() => _LangModalBottomSheetState();
}

class _LangModalBottomSheetState extends State<LangModalBottomSheet> {
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

  @override
  Widget build(BuildContext context) {
    return langModalBottomSheet(context);
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
}
