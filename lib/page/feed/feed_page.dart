import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:mirize/tools/state/database.dart';
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
  List postsList = [];

  @override
  void initState() {
    super.initState();
    // fetchDatabaseList(context);
  }

  // fetchDatabaseList(context) {
  //   var authstate = Provider.of<CloudFirestore>(context, listen: false);
  //   dynamic result = authstate.getPostList();

  //   if (result == null) {
  //     print("Unable to retrieve");
  //   } else {
  //     setState(() {
  //       postsList = result;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: FutureBuilder(
              future: FirebaseFirestore.instance.collection("posts").get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: ListView(
                        children: snapshot.data.docs.map<Widget>((document) {
                      var authstate =
                          Provider.of<CloudFirestore>(context, listen: false);
                      var uidUser = document["uidUser"];
                      print(uidUser);
                      authstate.getUserFromUid(uidUser).then((uid) {
                        
                      });
                      return Container(
                        width: 400,
                        height: 200,
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Expanded(
                                                          child: Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(50),
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            child: CachedNetworkImage(
                                              imageUrl: document["imagePath"],
                                              imageBuilder:
                                                  (context, imageProvider) =>
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
                                              placeholder: (context, url) =>
                                                  Container(
                                                color: Color(0xffeeeeee),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Text("USERNAME"),
                                        )
                                      ],
                                    ),
                                    IconButton(
                                      icon: Icon(Typicons.forward),
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                                                          child: Container(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    width: 100,
                                    child: CachedNetworkImage(
                                      imageUrl: document["imagePath"],
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
                              ),
                            )
                          ],
                        ),
                      );
                    }).toList()),
                  );
                } else {
                  return Container(
                    height: 75,
                    width: 75,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
