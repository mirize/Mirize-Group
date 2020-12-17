import 'package:flutter/material.dart';
import 'package:mirize/model/comment.dart';
import 'package:mirize/model/post.dart';
import 'package:mirize/page/feed/post/comment/commented_list.dart';
import 'package:mirize/page/feed/post/posts_list.dart';
import 'package:mirize/tools/state/feed_state.dart';
import 'package:provider/provider.dart';

class FeedPage extends StatefulWidget {
  FeedPage(
      {Key key,
      GlobalKey<ScaffoldState> scaffoldKey,
      GlobalKey<RefreshIndicatorState> refreshIndicatorKey})
      : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Post>>.value(
      value: FeedState().posts,
      child: Scaffold(
        body: PostsList(),
        backgroundColor: Color.fromRGBO(237, 238, 240, 1),
      ),
    );
  }
}
