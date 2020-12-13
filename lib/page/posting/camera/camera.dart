import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter_lantern/flutter_lantern.dart';
// import 'package:custom_image_picker/custom_image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with TickerProviderStateMixin {
  List<CameraDescription> cameras;
  CameraController _cameraController;
  List<dynamic> _galleryPhotos;
  int selectedCameraIndex;
  bool _getPhoto = false;
  bool isFront = false;
  bool isTorch = false;
  var _galleryPhotosURI;
  var uuidPhoto = Uuid();

  @override
  void initState() {
    // getImagesFromGallery();
    super.initState();
    availableCameras().then((availableCameras) {
      cameras = availableCameras;

      if (cameras.length > 0) {
        setState(() {
          selectedCameraIndex = 0;
        });
        _initCameraController(cameras[selectedCameraIndex]).then((void v) {});
      } else {
        print('No camera available');
      }
    }).catchError((err) {
      print('Error :${err.code}Error message : ${err.message}');
    });
  }

  Future _initCameraController(CameraDescription cameraDescription) async {
    if (_cameraController != null) {
      await _cameraController.dispose();
    }
    _cameraController =
        CameraController(cameraDescription, ResolutionPreset.high);

    _cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }

      if (_cameraController.value.hasError) {
        print('Camera error ${_cameraController.value.errorDescription}');
      }
    });
    try {
      await _cameraController.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }
    if (mounted) {
      setState(() {});
    }
  }

  // Future<void> getImagesFromGallery() async {
  //   CustomImagePicker.getAllImages.then((value) {
  //     setState(() {
  //       _galleryPhotos = value;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController.value.isInitialized) {
      return Container(
        height: 0.0,
        width: 0.0,
      );
    }
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.3),
      body: Stack(
        children: <Widget>[
          AnimatedContainer(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInCubic,
            height: double.infinity,
            child: Container(
              width: double.infinity,
              child: _getPhoto
                  ? Container(
                      child: Image.file(
                        File(_galleryPhotosURI),
                        fit: BoxFit.fitWidth,
                      ),
                    )
                  : CameraPreview(_cameraController),
            ),
          ),
          _setTextContainer(),
          _cameraButtonWidget(context),
          _galleryWidget(context),
        ],
      ),
    );
  }

  Widget getPhotoModalBottomSheet(context) {
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
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: GridView.builder(
                              reverse: true,
                              controller: controller,
                              scrollDirection: Axis.vertical,
                              itemCount: _galleryPhotos.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4),
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _getPhoto = true;
                                      _galleryPhotosURI = _galleryPhotos[index];
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(2),
                                    height: 55,
                                    width: 55,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.file(
                                        File(_galleryPhotos[index]),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
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

  Widget _setTextContainer() {
    return Positioned(
      bottom: 75,
      right: 0,
      left: 0,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeIn,
        height: _getPhoto ? 45 : 0,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.6)),
          child: TextField(
            cursorColor: Colors.white,
            keyboardType: TextInputType.text,
            style: TextStyle(
                fontSize: 16, fontFamily: "Nunito", color: Colors.black),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 10),
              isCollapsed: true,
              hintText: 'Hint Text',
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget _cameraButtonWidget(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeIn,
        height: _getPhoto ? 75 : 110,
        child: Container(
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.6)),
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _getPhoto
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          _getPhoto = false;
                          _galleryPhotosURI = null;
                        });
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        child: Icon(
                          Icons.close_rounded,
                          color: Colors.black.withOpacity(0.4),
                          size: 30,
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () async {
                        bool hasLamp = await Lantern.hasLamp;
                        if (hasLamp) {
                          if (isTorch) {
                            Lantern.turnOn();
                            Lantern.turnOn(intensity: 0.4);
                          } else {
                            Lantern.turnOff();
                          }
                          setState(() {
                            isTorch = !isTorch;
                          });
                        }
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        child: Icon(
                          Icons.flash_on,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
              GestureDetector(
                onTap: () {
                  _takePhoto(context);
                },
                child: Container(
                  height: _getPhoto ? 50 : 80,
                  width: _getPhoto ? 50 : 80,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      border: Border.all(
                          color: _getPhoto
                              ? Colors.black.withOpacity(0.4)
                              : Colors.white,
                          width: 4)),
                  child: Center(
                    child: _getPhoto
                        ? Icon(Icons.done,
                            size: 25, color: Colors.black.withOpacity(0.4))
                        : Icon(Icons.center_focus_weak,
                            size: 45, color: Colors.white),
                  ),
                ),
              ),
              _getPhoto
                  ? GestureDetector(
                      onTap: () {},
                      onLongPress: () {},
                      child: Container(
                        height: 50,
                        width: 50,
                        child: Icon(
                          Icons.more_vert_rounded,
                          size: 30,
                          color: Colors.black.withOpacity(0.4),
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        if (cameras == null || cameras.isEmpty) {
                          return Spacer();
                        }
                        selectedCameraIndex =
                            selectedCameraIndex < cameras.length - 1
                                ? selectedCameraIndex + 1
                                : 0;
                        CameraDescription selectedCamera =
                            cameras[selectedCameraIndex];
                        _initCameraController(selectedCamera);
                      },
                      onLongPress: () {},
                      child: Container(
                        height: 50,
                        width: 50,
                        child: Icon(
                          Icons.flip_camera_android,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget _galleryWidget(BuildContext context) {
    return Positioned(
      bottom: 130,
      right: 15,
      left: 15,
      child: GestureDetector(
        onPanUpdate: (details) {
          if (details.delta.dy < 10) {
            getPhotoModalBottomSheet(context);
          }
        },
        child: Column(
          children: [
            Container(
              width: 100,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                borderRadius: BorderRadius.circular(10),
              ),
              height: 5,
              margin: EdgeInsets.symmetric(vertical: 10),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              height: 75,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white.withOpacity(0.6)),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 7,
                itemBuilder: (_, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _getPhoto = true;
                        _galleryPhotosURI = _galleryPhotos[index];
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      height: 55,
                      width: 55,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          File(_galleryPhotos[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _takePhoto(BuildContext context) async {
    if (!_cameraController.value.isInitialized) {
      print("!_cameraController.value.isInitialized");
      return null;
    }
    if (_cameraController.value.isTakingPicture) {
      print("_cameraController.value.isTakingPicture");
      return null;
    }
    try {
      final Directory extDir = await getExternalStorageDirectory();
      final String dirPath = '${extDir.path}/mirize/photos';
      await Directory(dirPath).create(recursive: true);
      String uriLink = uuidPhoto.v1();
      final String filePath = '$dirPath/${uriLink}.png';
      await _cameraController.takePicture(filePath);
      String mirizeName = "mirize";
      GallerySaver.saveImage(filePath, albumName: mirizeName)
          .then((bool success) {
        setState(() {
          print(filePath);
        });
      });
      setState(() {
        _getPhoto = true;
        _galleryPhotosURI = filePath;
      });
    } catch (e) {
      _showCameraException(e);
    }
  }

  void _showCameraException(CameraException e) {
    String errorText = 'Error:${e.code}\nError message : ${e.description}';
    print(errorText);
  }
}
