import 'package:flutter/material.dart';
import 'package:mirize/helper/constant.dart';
import 'package:mirize/helper/theme.dart';
import 'package:mirize/helper/utility.dart';
import 'package:mirize/model/user.dart';
import 'package:mirize/state/searchState.dart';
import 'package:mirize/widgets/customAppBar.dart';
import 'package:mirize/widgets/customWidgets.dart';
import 'package:mirize/widgets/newWidget/customUrlText.dart';
import 'package:mirize/widgets/newWidget/title_text.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key key, this.scaffoldKey}) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = Provider.of<SearchState>(context, listen: false);
      state.resetFilterList();
    });
    super.initState();
  }

  void onSettingIconPressed() {
    Navigator.pushNamed(context, '/TrendsPage');
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<SearchState>(context);
    final list = state.userlist;
    return Scaffold(
      appBar: CustomAppBar(
        scaffoldKey: widget.scaffoldKey,
        icon: AppIcon.settings,
        onActionPressed: onSettingIconPressed,
        onSearchChanged: (text) {
          state.filterByUsername(text);
        },
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          state.getDataFromDatabase();
          return Future.value(true);
        },
        child: ListView.separated(
          addAutomaticKeepAlives: false,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) => _UserTile(user: list[index]),
          separatorBuilder: (_, index) => Divider(
            height: 0,
          ),
          itemCount: list?.length ?? 0,
        ),
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  const _UserTile({Key key, this.user}) : super(key: key);
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        kAnalytics.logViewSearchResults(searchTerm: user.userName);
        Navigator.of(context).pushNamed('/ProfilePage/' + user?.userId);
      },
      leading: customImage(context, user.profilePic, height: 40),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
            child: TitleText(user.displayName,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                overflow: TextOverflow.ellipsis),
          ),
          SizedBox(width: 3),
          user.isVerified
              ? customIcon(
                  context,
                  icon: AppIcon.blueTick,
                  istwitterIcon: true,
                  iconColor: AppColor.primary,
                  size: 13,
                  paddingIcon: 3,
                )
              : SizedBox(width: 0),
        ],
      ),
      subtitle: Text(user.userName),
    );
  }
}
