import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:mirize/page/posting/camera/camera.dart';

class FeedScreen extends StatefulWidget {
  FeedScreen({Key key}) : super(key: key);
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        primary: false,
        slivers: [
          SliverAppBar(
            snap: true,
            elevation: 0,
            pinned: false,
            // expandedHeight: 100,
            brightness: Brightness.dark,
            backgroundColor: Color.fromRGBO(250, 250, 250, 1),
            // flexibleSpace: FlexibleSpaceBar(
            //   title: ListView(
            //     scrollDirection: Axis.horizontal,
            //     children: [
            //       AspectRatio(
            //         aspectRatio: 2 / 1,
            //         child: Container(
            //           margin: EdgeInsets.only(right: 10),
            //           decoration: BoxDecoration(
            //               color: Colors.grey.shade200,
            //               borderRadius: BorderRadius.all(Radius.circular(10))),
            //           child: Center(child: Text('Data')),
            //         ),
            //       ),
            //       AspectRatio(
            //         aspectRatio: 2 / 1,
            //         child: Container(
            //           decoration: BoxDecoration(
            //               color: Colors.grey.shade200,
            //               borderRadius: BorderRadius.all(Radius.circular(10))),
            //           child: Center(child: Text('Data')),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // title: TextField(
            //   cursorColor: Colors.black45,
            //   keyboardType: TextInputType.text,
            //   style: TextStyle(fontSize: 16, fontFamily: "Nunito"),
            //   decoration: InputDecoration(
            //       hintText: 'Search',
            //       isCollapsed: true,
            //       border: OutlineInputBorder(
            //           borderRadius: BorderRadius.circular(10),
            //           borderSide: BorderSide.none),
            //       filled: true,
            //       fillColor: Color.fromRGBO(45, 45, 45, .05),
            //       contentPadding:
            //           EdgeInsets.symmetric(vertical: 7, horizontal: 10)),
            // ),
            title: Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('#лучше',
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 20,
                        fontFamily: "Nunito")),
                Text('дома',
                    style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 20,
                        fontFamily: "Nunito")),
              ],
            ),
            centerTitle: true,
            floating: true,
            actions: [
              IconButton(
                  icon: Icon(
                    Typicons.flash_outline,
                    color: Colors.grey.shade600,
                  ),
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (_) => CreatingPostsScreens()),
                    // );
                    // AuthService().signOut();
                  }),
            ],
          ),
          // SliverList(
          //   delegate: SliverChildBuilderDelegate(
          //     (context, index) {
          //       return FadeAnimation(
          //           1.5,
          //           adMakeItem(
          //               image: 'assets/images/no_full_logo_mg_200.png',
          //               tag: 'red',
          //               context: context));
          //     },
          //     childCount: 1,
          //   ),
          // )
        ],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          iconSize: 25.0,
          elevation: 0,
          backgroundColor: Colors.grey.shade200,
          selectedItemColor: Colors.grey.shade700,
          unselectedItemColor: Colors.grey.shade400,
          currentIndex: _currentIndex,
          onTap: (value) {
            setState(() => _currentIndex = value);
            if (_currentIndex == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => FeedScreen()),
              );
            } else if (_currentIndex == 1) {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (_) => AdShopScreen()),
              // );
            } else if (_currentIndex == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CameraPage()),
              );
            } else if (_currentIndex == 3) {
            } else if (_currentIndex == 4) {}
          },
          items: [
            BottomNavigationBarItem(
              title: SizedBox(),
              icon: Icon(FontAwesome5.fire),
            ),
            BottomNavigationBarItem(
              title: SizedBox(),
              icon: Icon(FontAwesome5.search),
            ),
            BottomNavigationBarItem(
              title: SizedBox(),
              icon: Icon(FontAwesome5.plus_circle),
            ),
            BottomNavigationBarItem(
              title: SizedBox(),
              icon: Icon(FontAwesome5.bookmark),
            ),
            BottomNavigationBarItem(
              title: SizedBox(),
              icon: Icon(FontAwesome5.user_alt),
            ),
          ],
        ),
      ),
    );
  }
}
