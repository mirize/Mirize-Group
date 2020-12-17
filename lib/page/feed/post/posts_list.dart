import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mirize/model/post.dart';
import 'package:mirize/page/feed/post/post_widget.dart';
import 'package:provider/provider.dart';

class PostsList extends StatefulWidget {
  PostsList({Key key}) : super(key: key);

  @override
  _PostsListState createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  @override
  Widget build(BuildContext context) {
    final posts = Provider.of<List<Post>>(context);
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return PostWidget(post: posts[index]);
      },
    );
  }
}
