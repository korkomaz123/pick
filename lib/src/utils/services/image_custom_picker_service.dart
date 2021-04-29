import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

class ImageCustomPickerService {
  ImageCustomPickerService({
    @required this.context,
    @required this.backgroundColor,
    @required this.titleColor,
    @required this.video,
    this.galleryTitle = 'From Gallery',
    this.cameraTitle = 'From Camera',
  });

  final BuildContext context;
  final Color backgroundColor;
  final Color titleColor;
  final bool video;
  final String galleryTitle;
  final String cameraTitle;

  Future<File> getImageWithDialog() async {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var result = await showDialog(
      context: context,
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: _buildPickSourceDialog(width: width, height: height),
        );
      },
    );
    if (result == null) {
      return null;
    }
    PickedFile file;
    try {
      if (result.toString() == 'gallery') {
        file = await ImagePicker().getImage(source: ImageSource.gallery);
      } else {
        file = await ImagePicker().getImage(source: ImageSource.camera);
      }
      File croppedFile = await ImageCropper.cropImage(
        sourcePath: file.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ),
      );
      return croppedFile;
    } catch (e) {
      print('-------------------------------------------------');
      print('cancelled picker or cropper');
      print('-------------------------------------------------');
      return null;
    }
  }

  Widget _buildPickSourceDialog({double width, double height}) {
    return Container(
      margin: EdgeInsets.only(top: height * 0.8),
      color: backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          InkWell(
            onTap: () => Navigator.pop(context, 'gallery'),
            child: Container(
              width: width * 0.9,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                children: <Widget>[
                  Icon(Icons.image, color: titleColor),
                  SizedBox(width: 10),
                  Text(galleryTitle, style: TextStyle(color: titleColor)),
                ],
              ),
            ),
          ),
          Divider(color: titleColor.withOpacity(0.6), height: 3, thickness: 1),
          InkWell(
            onTap: () => Navigator.pop(context, 'camera'),
            child: Container(
              width: width * 0.9,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                children: <Widget>[
                  Icon(Icons.camera_alt, color: titleColor),
                  SizedBox(width: 10),
                  Text(cameraTitle, style: TextStyle(color: titleColor)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
