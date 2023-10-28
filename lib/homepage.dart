// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:Celebrare/alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:widget_mask/widget_mask.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  File? _image;
  late CroppedFile _croppedFile;
  bool show = false;
  bool ismask = false;
  late Image resultantImage;

  void _setImage(File image) {
    setState(() {
      _image = image;
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final pickedFile = await _picker
        .pickImage(source: ImageSource.gallery)
        .then((value) => _cropImage(value));
  }

  Future<void> _cropImage(_pickedFile) async {
    if (_pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _pickedFile!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Crop',
              toolbarColor: Colors.teal,
              hideBottomControls: false,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          _croppedFile = croppedFile;
        });
      }
    }
  }

  void updateImageDetails(bool showvalue, bool ismask, Image resultZImage) {
    setState(() {
      show = showvalue;
      this.ismask = ismask;
      resultantImage = resultZImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Add Image / Icon",
          style: TextStyle(color: Colors.black54),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            icon: Icon(
              CupertinoIcons.back,
              color: Colors.black54,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black54),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Upload Image"),
                  ElevatedButton(
                      onPressed: () {
                        _pickImage().then((value) {
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialogImage(
                                    croppedFile: _croppedFile,
                                    updateImageVisibility: updateImageDetails,
                                  ));
                        });
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => Colors.teal)),
                      child: Text("Choose from Device"))
                ],
              ),
            ),
            show == true
                ? ismask
                    ? Expanded(
                        child: Container(
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 20),
                                child: Container(
                                  width: double.infinity,
                                  height: 170,
                                  child: WidgetMask(
                                      blendMode: BlendMode.srcATop,
                                      childSaveLayer: true,
                                      mask: Image.file(
                                        File(_croppedFile.path),
                                        fit: BoxFit.cover,
                                      ),
                                      child: resultantImage),
                                ))))
                    : Expanded(
                        child: Container(
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 20),
                                child: Container(
                                  width: double.infinity,
                                  height: 170,
                                  child: Image.file(
                                    File(_croppedFile.path),
                                    fit: BoxFit.cover,
                                  ),
                                ))))
                : SizedBox()
          ],
        ),
      ),
    );
  }
}
