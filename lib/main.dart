import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mirize/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mirize/tools/routes.dart';
import 'package:mirize/tools/state/app_state.dart';
import 'package:mirize/tools/state/database.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyHome());
}

class MyHome extends StatefulWidget {
  MyHome({Key key}) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) async {
    _MyHomeState state = context.findAncestorStateOfType<_MyHomeState>();
    state.changeLanguage(newLocale);
  }

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  Locale _locale;

  changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>(create: (_) => AppState()),
        ChangeNotifierProvider<CloudFirestore>(create: (_) => CloudFirestore()),
      ],
      child: MaterialApp(
        theme: ThemeData(fontFamily: "Nunito"),
        supportedLocales: [
          Locale("ru", "RU"),
          Locale('en', "US"),
          Locale("uk", "UK"),
          Locale("ar", "AR"),
          Locale("bn", "BN"),
          Locale("es", "ES"),
          Locale("hi", "HI"),
          Locale("pt", "PT"),
          Locale("ro", "RO"),
          Locale("zh", "ZH"),
          Locale("fr", "FR"),
          Locale("de", "DE"),
          Locale("it", "IT"),
          Locale("ja", "JA"),
        ],
        locale: _locale,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocates) {
          for (var supportedLocale in supportedLocates) {
            if (supportedLocale.languageCode == locale.languageCode &&
                supportedLocale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }
          return supportedLocates.first;
        },
        debugShowCheckedModeBanner: false,
        routes: Routes.route(),
        onGenerateRoute: (settings) => Routes.onGenerateRoute(settings),
        initialRoute: "SplashPage",
      ),
    );
  }
}
