import 'package:flutter/material.dart';
import 'package:mirize/page/feed/feed_page.dart';
import 'package:mirize/page/notifications/notification_page.dart';
import 'package:mirize/page/posting/camera/camera.dart';
import 'package:mirize/page/posting/posting_page.dart';
import 'package:mirize/page/profile/profile.dart';
import 'package:mirize/page/search/search_page.dart';
import 'package:mirize/tools/state/app_state.dart';
import 'package:mirize/widgets/navigation/bottom_bar_navigation.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  int pageIndex = 0;

  Widget _body() {
    return SafeArea(
      child: _getPage(Provider.of<AppState>(context).pageIndex),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return FeedPage(
          scaffoldKey: _scaffoldKey,
          refreshIndicatorKey: refreshIndicatorKey,
        );
        break;
      case 1:
        return SearchPage(scaffoldKey: _scaffoldKey);
        break;
      case 2:
        return PostingPage(scaffoldKey: _scaffoldKey);
        break;
      case 3:
        return NotificationPage(scaffoldKey: _scaffoldKey);
        break;
      case 4:
        return ProfilePage(scaffoldKey: _scaffoldKey);
        break;
      default:
        return FeedPage(scaffoldKey: _scaffoldKey);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      bottomNavigationBar: BottomMenubar(),
      body: _body(),
    );
  }
}
