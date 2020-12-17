import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:mirize/model/comment.dart';
import 'package:mirize/model/post.dart';
import 'package:mirize/page/feed/post/comment/commented_list.dart';
import 'package:mirize/tools/state/database.dart';
import 'package:mirize/tools/state/feed_state.dart';
import 'package:mirize/widgets/flatButtonCustom.dart';
import 'package:mirize/widgets/textFieldCustom.dart';
import 'package:provider/provider.dart';

class PostWidget extends StatefulWidget {
  final Post post;
  PostWidget({this.post});
  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  var photo;
  var phone;
  var commentLength;
  var comment;
  TextEditingController _textCommented = TextEditingController();
  @override
  void initState() {
    super.initState();
    _textCommented = TextEditingController();
    init();
    initComment();
  }

  @override
  void dispose() {
    _textCommented.dispose();
    super.dispose();
  }

  commentedModalBottomSheet(context, uidPost) {
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
            } else if (notification.extent <= 0.77) {}
          },
          child: DraggableScrollableActuator(
            child: DraggableScrollableSheet(
              minChildSize: 0.3,
              initialChildSize: 0.6,
              maxChildSize: 0.9,
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
                      Container(
                        margin: EdgeInsets.only(top: 10, bottom: 20),
                        width: 75,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(120, 150, 255, 0.4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 5,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: [
                            TextFieldCustom().textFieldCommentedPost(
                                _textCommented,
                                "Напишите комментарий",
                                false,
                                true,
                                true,
                                false,
                                () {},
                                () {}),
                            FlatButtonCustom().flatButtonCommented(() {
                              var state = Provider.of<CloudFirestore>(context,
                                  listen: false);
                              state.createdComment(
                                  context,
                                  _textCommented.text.trim(),
                                  FirebaseAuth.instance.currentUser.uid,
                                  uidPost);
                            }),
                          ],
                        ),
                      ),
                      Expanded(
                        child: StreamProvider<List<Comment>>.value(
                          value: FeedState(uid: widget.post.idPost).comment,
                          child: CommentedList(),
                        ),
                      )
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

  init() async {
    String uid = widget.post.uidUser;
    photo = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((value) {
      return phone = value.data()["uriImage"];
    });
    return photo;
  }

  initComment() async {
    String uid = widget.post.idPost;
    commentLength = await FirebaseFirestore.instance
        .collection("posts")
        .doc(uid)
        .collection("comment")
        .get()
        .then((value) {
      return comment = value.docs.length;
    });
    return commentLength;
  }

  bool taped = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                taped = !taped;
              });
            },
            child: AspectRatio(
              aspectRatio: 1,
              child: CachedNetworkImage(
                width: double.infinity,
                imageUrl: widget.post.imagePath,
                useOldImageOnUrlChange: true,
                fit: BoxFit.fitWidth,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: AnimatedOpacity(
                          opacity: taped ? 1 : 0,
                          alwaysIncludeSemantics: true,
                          curve: Curves.easeInQuart,
                          duration: Duration(milliseconds: 400),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.black54.withOpacity(0.4),
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(18))),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        commentedModalBottomSheet(
                                            context, widget.post.idPost);
                                      },
                                      icon: Icon(
                                        Typicons.eq,
                                        color: Colors.white54.withOpacity(0.7),
                                      ),
                                    ),
                                    Text(
                                      "${commentLength}",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color:
                                              Colors.white54.withOpacity(0.7)),
                                    ),
                                  ],
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    child: CachedNetworkImage(
                                      imageUrl: photo,
                                      useOldImageOnUrlChange: true,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      placeholderFadeInDuration:
                                          Duration(milliseconds: 500),
                                      placeholder: (context, url) => Container(
                                        color: Color(0xffeeeeee),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Typicons.forward,
                                        color: Colors.white54.withOpacity(0.7),
                                      ),
                                    ),
                                    Text(
                                      "1313",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white54.withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -0.5,
                        left: 0,
                        right: 0,
                        child: AnimatedOpacity(
                          opacity: taped ? 1 : 0,
                          alwaysIncludeSemantics: true,
                          curve: Curves.easeInQuart,
                          duration: Duration(milliseconds: 400),
                          child: Container(
                            color: Colors.black54.withOpacity(0.4),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    widget.post.textPost,
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.white70),
                                  ),
                                )),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Typicons.heart_filled,
                                    color: Colors.white70.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                placeholderFadeInDuration: Duration(milliseconds: 500),
                placeholder: (context, url) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.withOpacity(0.2),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.red.withOpacity(0.1),
                  child: Center(
                    child: Icon(
                      Icons.error,
                      color: Colors.red.withOpacity(0.6),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 35,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(20))),
            child: Row(
              children: [
                Row(
                  children: [],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
