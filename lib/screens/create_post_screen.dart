import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:mirize/tools/models/file.dart';
import 'package:storage_path/storage_path.dart';

class PostCreation extends StatefulWidget {
  PostCreation({Key key}) : super(key: key);

  @override
  _PostCreationState createState() => _PostCreationState();
}

class _PostCreationState extends State<PostCreation>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _heightFactorAnimation;
  double collapsedHeightFactor = 0.70;
  double expendedHeightFactor = 0.30;
  bool isAnimationCompleted = false;
  double screenHeight = 0;

  List<FileModel> files;
  FileModel selectedModel;
  String image;
  // File image_uri;
  @override
  void initState() {
    super.initState();
    getImagesPath();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));
    _heightFactorAnimation =
        Tween<double>(begin: collapsedHeightFactor, end: expendedHeightFactor)
            .animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  onBottomPartTap() {
    setState(() {
      if (isAnimationCompleted) {
        _controller.fling(velocity: -1);
      } else {
        _controller.fling(velocity: 1);
      }
      isAnimationCompleted = !isAnimationCompleted;
    });
  }

  Widget getWidgetSelectingPhoto() {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        FractionallySizedBox(
          alignment: Alignment.topCenter,
          heightFactor: _heightFactorAnimation.value,
          child: Container(
              child: image != null
                  ? Image.file(File(image),
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width)
                  : Container()),
        ),
        GestureDetector(
          onTap: onBottomPartTap,
          onVerticalDragUpdate: _handleVerticalUpdate,
          onVerticalDragEnd: _handleVerticalEnd,
          child: FractionallySizedBox(
            alignment: Alignment.bottomCenter,
            heightFactor: 1.05 - _heightFactorAnimation.value,
            child: selectedModel == null && selectedModel.files.length < 1
                ? Container()
                : Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(235, 235, 235, 1),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    padding: EdgeInsets.only(top: 40, left: 10, right: 10),
                    child: GridView.builder(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        reverse: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 7,
                            mainAxisSpacing: 7),
                        itemBuilder: (_, i) {
                          var file = selectedModel.files[i];
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: GestureDetector(
                              child: Image.file(
                                File(file),
                                fit: BoxFit.cover,
                              ),
                              onTap: () {
                                setState(() {
                                  image = file;
                                });
                              },
                            ),
                          );
                        },
                        itemCount: selectedModel.files.length),
                  ),
          ),
        ),
      ],
    );
  }

  _handleVerticalUpdate(DragUpdateDetails updateDetails) {
    double fractionDragged = updateDetails.primaryDelta / screenHeight;
    _controller.value = _controller.value - fractionDragged;
  }

  _handleVerticalEnd(DragEndDetails endDetails) {
    if (_controller.value >= 0.5) {
      _controller.fling(velocity: 1);
    } else {
      _controller.fling(velocity: -1);
    }
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

  void _onButtonTextPost() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            children: [
              image != null
                  ? Image.file(File(image),
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.topCenter,
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * 0.5)
                  : Container(),
              TextField(
                decoration: InputDecoration(hintText: "Enter text to post"),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    print("HELP TOOL: " + image);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(250, 250, 250, 1),
        brightness: Brightness.dark,
        elevation: 0,
        leading: BackButton(
          color: Colors.grey.shade600,
        ),
        title: DropdownButtonHideUnderline(
            child: DropdownButton<FileModel>(
          elevation: 1,
          isDense: true,
          style: TextStyle(
              color: Colors.black26, fontFamily: "Nunito", fontSize: 15),
          items: getItems(),
          onChanged: (FileModel d) {
            assert(d.files.length > 0);
            image = d.files[0];
            setState(() {
              selectedModel = d;
            });
          },
          value: selectedModel,
        )),
        actions: [
          IconButton(
              icon: Icon(
                Typicons.sort_alphabet_outline,
                color: Colors.grey.shade600,
              ),
              onPressed: _onButtonTextPost),
          IconButton(
              icon: Icon(
                Typicons.direction_outline,
                color: Colors.grey.shade600,
              ),
              onPressed: () {
                if (image == null) {
                  print("debil");
                } else {
                  Future<String> urlDownload(data) async {
                    StorageReference ref =
                        FirebaseStorage.instance.ref().child("post_uid.jpg");
                    StorageUploadTask uploadTask = ref.putFile(data);

                    String downloadUrl = await (await uploadTask.onComplete)
                        .ref
                        .getDownloadURL();
                    print("url" + image);
                    print(downloadUrl);
                    return downloadUrl;
                  }

                  print("HELP TOOL: " + image);

                  urlDownload(image);
                }
              })
        ],
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, widget) {
          return getWidgetSelectingPhoto();
        },
      ),
    );
  }

  List<DropdownMenuItem> getItems() {
    return files
            .map((e) => DropdownMenuItem(
                  child: Text(
                    e.folder,
                    style: TextStyle(color: Colors.black),
                  ),
                  value: e,
                ))
            .toList() ??
        [];
  }
}
