import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:core';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mirize/model/file.dart';
import 'package:mirize/tools/state/database.dart';
import 'package:mirize/widgets/textFieldCustom.dart';
import 'package:provider/provider.dart';
import 'package:storage_path/storage_path.dart';
import 'package:uuid/uuid.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String verificationID, image, downloadURI;
  TextEditingController _nameRegister;
  TextEditingController _surnameRegister;
  TextEditingController _usernameRegister;
  int currentPage = 0;
  int lastPage;
  List<FileModel> files;
  FileModel selectedModel;
  double _progress, dataLongitude, dataLatitude;
  StreamSubscription<Position> _positionStream;
  bool uploaded = false;
  Address _address;

  @override
  void initState() {
    _nameRegister = TextEditingController();
    _surnameRegister = TextEditingController();
    _usernameRegister = TextEditingController();
    getImagesPath();
    super.initState();
  }

  @override
  void dispose() {
    _nameRegister.dispose();
    _surnameRegister.dispose();
    _usernameRegister.dispose();
    super.dispose();
  }

  Future<Address> getAddressbaseOnLocation(Coordinates coordinates) async {
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    return addresses.first;
  }

  getCurrentLocation() async {
    _positionStream = Geolocator.getPositionStream(
            desiredAccuracy: LocationAccuracy.high, distanceFilter: 10)
        .listen((Position position) {
      print(position);
      setState(() {
        dataLongitude = position.longitude;
        dataLatitude = position.latitude;
      });
      final coordinates = Coordinates(position.latitude, position.longitude);
      getAddressbaseOnLocation(coordinates).then((value) => _address = value);
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

  uploadedImage(images) async {
    setState(() {
      uploaded = true;
    });
    String randomName;
    randomName = Uuid().v1();
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('avatars/${randomName}.png');
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: GestureDetector(
              onTap: () {
                getPhotoModalBottomSheet(context);
              },
              child: Container(
                margin:
                    EdgeInsets.only(top: 45, left: 25, right: 25, bottom: 15),
                width: double.infinity,
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/rounted/rounted_icon_100.png",
                              height: 35,
                              width: 35,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Text(
                                "connect",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 35),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Center(
                              child: Text(
                                "Register",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color.fromRGBO(45, 48, 71, 1),
                                ),
                              ),
                            ),
                          ),
                          Stack(
                            children: [
                              Container(
                                height: 75,
                                width: 75,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: image != null
                                      ? Image.file(
                                          File(image),
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          child: Center(
                                            child: Icon(Icons.camera),
                                          ),
                                        ),
                                ),
                              ),
                              uploaded
                                  ? Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                        height: 25,
                                        padding: downloadURI != null
                                            ? EdgeInsets.all(0)
                                            : EdgeInsets.all(5),
                                        width: 25,
                                        decoration: BoxDecoration(
                                            color: downloadURI != null
                                                ? Color.fromRGBO(49, 203, 0, 1)
                                                : Colors.white.withOpacity(0.7),
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        child: downloadURI != null
                                            ? Container(
                                                alignment: Alignment.center,
                                                child: Center(
                                                    child: Icon(
                                                  Icons.check_rounded,
                                                  color: Colors.white,
                                                )),
                                              )
                                            : CircularProgressIndicator(
                                                value: _progress,
                                                strokeWidth: 2,
                                              ),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromRGBO(255, 250, 255, 1),
                  ),
                  child: TextFieldCustom().textField(_usernameRegister,
                      "Username", false, false, false, () {}, () {}),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromRGBO(255, 250, 255, 1),
                  ),
                  child: Container(
                    height: 40,
                    padding: EdgeInsets.only(left: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromRGBO(247, 247, 247, 1),
                    ),
                    child: Row(
                      children: [
                        _address != null
                            ? Text('${_address.locality}',
                                style: TextStyle(
                                    color: Color.fromRGBO(39, 39, 39, 0.7)))
                            : GestureDetector(
                                onTap: () {
                                  getCurrentLocation();
                                },
                                child: Text("Определить ваш город",
                                    style: TextStyle(
                                        color:
                                            Color.fromRGBO(39, 39, 39, 0.7))),
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: downloadURI != null
                ? FlatButton(
                    child: Text("Register"),
                    onPressed: () {
                      var state =
                          Provider.of<CloudFirestore>(context, listen: false);
                      if (downloadURI != null) {
                        state.createNewUser(_usernameRegister.text.trim(),
                            downloadURI, dataLatitude, dataLongitude);
                      }
                    },
                  )
                : FlatButton(
                    child: Text("Uploaded photo"),
                    onPressed: () {
                      uploadedImage(image);
                    },
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
