import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key, GlobalKey<ScaffoldState> scaffoldKey}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Text("SEARCH"),
    );
  }
}