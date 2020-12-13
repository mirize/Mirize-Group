import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:mirize/model/file.dart';
import 'package:mirize/tools/state/database.dart';
import 'package:provider/provider.dart';
import 'package:storage_path/storage_path.dart';
import 'package:uuid/uuid.dart';

class PostingPage extends StatefulWidget {
  PostingPage({Key key, GlobalKey<ScaffoldState> scaffoldKey})
      : super(key: key);

  @override
  _PostingPageState createState() => _PostingPageState();
}

class _PostingPageState extends State<PostingPage> {
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  String pathPhotoFromFirestore, path, username, image, downloadURI;
  List<FileModel> files;
  double _progress;
  FileModel selectedModel;
  TextEditingController _textPost = TextEditingController();

  load() async {
    var uid = _firebaseAuth.currentUser.uid;
    _firebaseFirestore
        .collection("users")
        .doc(uid)
        .get()
        .then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        username = snapshot["username"];
        pathPhotoFromFirestore = snapshot["uriImage"];
      });
    });
  }

  uploadedImage(images) async {
    String randomName;
    randomName = Uuid().v1();
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('posts/${randomName}.png');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(File(image));
    uploadTask.events.listen((event) {
      setState(() {
        _progress = event.snapshot.bytesTransferred.toDouble() /
            event.snapshot.totalByteCount.toDouble();
      });
      setState(() async {
        downloadURI = await firebaseStorageRef.getDownloadURL();
      });
    });
  }

  getImagesPath() async {
    var imagePath = await StoragePath.imagesPath;
    var images = jsonDecode(imagePath) as List;
    files = images.map<FileModel>((e) => FileModel.fromJson(e)).toList();
    if (files != null && files.length > 0)
      setState(() {
        selectedModel = files[0];
        image = files[0].files[0];
      });
  }

  getPhotoModalBottomSheet(context) {
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
              initialChildSize: 0.5,
              maxChildSize: 0.8,
              expand: false,
              builder: (context, controller) {
                return StatefulBuilder(
                    builder: (BuildContext context, StateSetter state) {
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
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: DropdownButtonHideUnderline(
                              child: DropdownButton<FileModel>(
                            isExpanded: true,
                            items: getItems(),
                            onChanged: (FileModel d) {
                              assert(d.files.length > 0);
                              image = d.files[0];
                              state(() {
                                selectedModel = d;
                              });
                            },
                            value: selectedModel,
                          )),
                        ),
                        selectedModel == null && selectedModel.files.length < 1
                            ? Container()
                            : Expanded(
                                child: GridView.builder(
                                    controller: controller,
                                    padding: EdgeInsets.all(10),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 4,
                                            crossAxisSpacing: 4,
                                            mainAxisSpacing: 4),
                                    itemBuilder: (_, i) {
                                      var file = selectedModel.files[i];
                                      return GestureDetector(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.file(
                                            File(file),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            image = file;
                                          });
                                          Navigator.pop(context);
                                        },
                                      );
                                    },
                                    itemCount: selectedModel.files.length),
                              )
                      ],
                    ),
                  );
                });
              },
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _textPost.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getImagesPath();
    load();
    _textPost = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Create Post",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                  IconButton(
                    icon: Icon(Typicons.direction),
                    onPressed: () {
                      if (downloadURI != null) {
                        var state =
                            Provider.of<CloudFirestore>(context, listen: false);
                        state.createNewPost(context, downloadURI,
                            _textPost.text, DateTime.now().toUtc().toString());
                        setState(() {
                          downloadURI = null;
                        });
                      } else {
                        uploadedImage(image);
                      }
                    },
                  )
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        height: 40,
                        width: 40,
                        color: Colors.grey[300],
                        child: pathPhotoFromFirestore != null
                            ? CachedNetworkImage(
                                imageUrl: pathPhotoFromFirestore,
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
                              )
                            : Container(),
                      ),
                    ),
                    username != null
                        ? Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Text(
                              username,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w200),
                            ),
                          )
                        : Container(
                            height: 10,
                            width: 50,
                            margin: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(5)),
                          ),
                  ],
                )),
          ),
          SliverToBoxAdapter(
            child: TextField(
              controller: _textPost,
              maxLines: 10,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                isCollapsed: true,
                hintText: "Введите сообщение...",
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                filled: false,
              ),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Row(
                children: [
                  Container(
                    height: 125,
                    width: 125,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: image != null
                          ? Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.file(
                                  File(image),
                                  fit: BoxFit.cover,
                                  height: 125,
                                  width: 125,
                                ),
                                Positioned(
                                  bottom: 5,
                                  right: -15,
                                  child: MaterialButton(
                                    onPressed: () =>
                                        getPhotoModalBottomSheet(context),
                                    color: _progress != null
                                        ? Colors.white30
                                        : Colors.blue[400],
                                    textColor: Colors.blue[100],
                                    child: _progress == null
                                        ? Icon(
                                            Typicons.attach,
                                            size: 22,
                                          )
                                        : CircularProgressIndicator(
                                            value: _progress,
                                          ),
                                    padding: EdgeInsets.all(10),
                                    enableFeedback:
                                        _progress == null ? false : true,
                                    shape: CircleBorder(),
                                  ),
                                )
                              ],
                            )
                          : Container(
                              child: Center(
                                child: Icon(Icons.camera),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem> getItems() {
    return files
            .map((e) => DropdownMenuItem(
                  child: Text(
                    e.folder,
                    style: TextStyle(color: Color.fromRGBO(45, 48, 71, 1)),
                  ),
                  value: e,
                ))
            .toList() ??
        [];
  }
}
