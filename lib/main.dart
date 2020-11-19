import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mirize/app_localizations.dart';
import 'package:mirize/helper/theme.dart';
import 'package:mirize/state/searchState.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'helper/routes.dart';
import 'state/appState.dart';
import 'package:provider/provider.dart';
import 'state/authState.dart';
import 'state/chats/chatState.dart';
import 'state/feedState.dart';
import 'package:google_fonts/google_fonts.dart';

import 'state/notificationState.dart';

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
        ChangeNotifierProvider<AuthState>(create: (_) => AuthState()),
        ChangeNotifierProvider<FeedState>(create: (_) => FeedState()),
        ChangeNotifierProvider<ChatState>(create: (_) => ChatState()),
        ChangeNotifierProvider<SearchState>(create: (_) => SearchState()),
        ChangeNotifierProvider<NotificationState>(
            create: (_) => NotificationState()),
      ],
      child: MaterialApp(
        theme: AppTheme.apptheme.copyWith(
          textTheme: GoogleFonts.muliTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
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
        onUnknownRoute: (settings) => Routes.onUnknownRoute(settings),
        initialRoute: "SplashPage",
      ),
    );
  }
}
