// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:widget_mask/widget_mask.dart';

class AlertDialogImage extends StatefulWidget {
  AlertDialogImage(
      {super.key,
      required this.croppedFile,
      required this.updateImageVisibility});
  final CroppedFile croppedFile;
  final Function updateImageVisibility;

  @override
  State<AlertDialogImage> createState() => _AlertDialogImageState();
}

class _AlertDialogImageState extends State<AlertDialogImage> {
  bool ismask = false;
  Image maskLayer = Image.asset("assets/images/frame1.png");
  GlobalKey _repaintBoundaryKey = GlobalKey();
  Image? _image;

  Future<void> _convertWidgetMaskToImage() async {
    RenderRepaintBoundary boundary = _repaintBoundaryKey.currentContext!
        .findRenderObject() as RenderRepaintBoundary;
    Image image = (await boundary.toImage()) as Image;

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.all(0),
      content: SizedBox(
        width: double.maxFinite,
        height: 420,
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.cancel,
                    size: 35,
                    color: Colors.grey,
                  )),
            ),
            Text(
              "Uploaded Image",
              style: TextStyle(fontSize: 24, color: Colors.black54),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Container(
                width: double.infinity,
                height: 170,
                // color: Colors.green,
                child: ismask
                    ? WidgetMask(
                        blendMode: BlendMode.srcATop,
                        childSaveLayer: true,
                        mask: Image.file(
                          File(widget.croppedFile.path),
                          width: 300,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                        child: maskLayer)
                    : Image.file(
                        File(widget.croppedFile.path),
                        width: 300,
                        height: 300,
                        fit: BoxFit.scaleDown,
                      ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    ismask = false;
                    setState(() {});
                  },
                  child: Container(
                    width: 80,
                    height: 50,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        "Original",
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    ismask = true;
                    maskLayer = Image.asset("assets/images/frame1.png");
                    setState(() {});
                  },
                  child: Container(
                    width: 60,
                    height: 50,
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.circular(10)),
                    child:
                        Center(child: Image.asset("assets/images/frame1.png")),
                  ),
                ),
                InkWell(
                  onTap: () {
                    ismask = true;
                    maskLayer = Image.asset("assets/images/frame2.png");
                    setState(() {});
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.circular(10)),
                    child:
                        Center(child: Image.asset("assets/images/frame2.png")),
                  ),
                ),
                InkWell(
                  onTap: () {
                    ismask = true;
                    maskLayer = Image.asset("assets/images/frame3.png");
                    setState(() {});
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.circular(10)),
                    child:
                        Center(child: Image.asset("assets/images/frame3.png")),
                  ),
                ),
                InkWell(
                  onTap: () {
                    ismask = true;
                    maskLayer = Image.asset("assets/images/frame4.png");
                    setState(() {});
                  },
                  child: Container(
                    width: 50,
                    height: 40,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.circular(10)),
                    child:
                        Center(child: Image.asset("assets/images/frame4.png")),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                    onPressed: () {
                      widget.updateImageVisibility(true, ismask, maskLayer);
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.teal)),
                    child: Text("Use this Image"))),
          ],
        ),
      ),
    );
  }
}
