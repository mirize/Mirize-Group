import 'package:flutter/material.dart';
import 'package:mirize/model/comment.dart';
import 'package:provider/provider.dart';

class CommentedList extends StatefulWidget {
  CommentedList({Key key}) : super(key: key);

  @override
  _CommentedListState createState() => _CommentedListState();
}

class _CommentedListState extends State<CommentedList> {
  @override
  Widget build(BuildContext context) {
    final comments = Provider.of<List<Comment>>(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: ListView.builder(
        itemCount: comments.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.grey[300].withOpacity(0.2),
                borderRadius: BorderRadius.circular(10)),
            child: Text(comments[index].uidComment),
          );
        },
      ),
    );
  }
}
