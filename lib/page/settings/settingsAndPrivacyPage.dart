import 'package:flutter/material.dart';
import 'package:mirize/helper/theme.dart';
import 'package:mirize/model/user.dart';
import 'package:mirize/page/settings/widgets/headerWidget.dart';
import 'package:mirize/state/authState.dart';
import 'package:mirize/widgets/customAppBar.dart';
import 'package:mirize/widgets/customWidgets.dart';
import 'package:mirize/widgets/newWidget/customUrlText.dart';
import 'package:provider/provider.dart';
import 'widgets/settingsRowWidget.dart';

class SettingsAndPrivacyPage extends StatelessWidget {
  const SettingsAndPrivacyPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<AuthState>(context).userModel ?? UserModel();
    return Scaffold(
      backgroundColor: TwitterColor.white,
      appBar: CustomAppBar(
        isBackButton: true,
        title: customTitleText(
          'Settings and privacy',
        ),
      ),
      body: ListView(
        children: <Widget>[
          HeaderWidget(user.userName),
          SettingRowWidget(
            "Account",
            navigateTo: 'AccountSettingsPage',
          ),
          Divider(height: 0),
          SettingRowWidget("Privacy and Policy",
              navigateTo: 'PrivacyAndSaftyPage'),
          SettingRowWidget("Notification", navigateTo: 'NotificationPage'),
          SettingRowWidget("Content prefrences",
              navigateTo: 'ContentPrefrencePage'),
          HeaderWidget(
            'General',
            secondHeader: true,
          ),
          SettingRowWidget("Display and Sound",
              navigateTo: 'DisplayAndSoundPage'),
          SettingRowWidget("Data usage", navigateTo: 'DataUsagePage'),
          SettingRowWidget("Accessibility", navigateTo: 'AccessibilityPage'),
          SettingRowWidget("Proxy", navigateTo: "ProxyPage"),
          SettingRowWidget(
            "About Fwitter",
            navigateTo: "AboutPage",
          ),
          SettingRowWidget(
            null,
            showDivider: false,
            vPadding: 10,
            subtitle:
                'These settings affect all of your Fwitter accounts on this devce.',
          )
        ],
      ),
    );
  }
}
