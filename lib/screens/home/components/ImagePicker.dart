import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:pikobar_flutter/components/CustomBottomSheet.dart';
import 'package:pikobar_flutter/components/RoundedButton.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/utilities/OCRHelper.dart';

class ImagePicker extends StatefulWidget {
  ImagePicker(
      {Key key, this.title, this.isRequired, this.imgToTextValue, this.image})
      : super(key: key);

  final String title;

  final bool isRequired;

  final Function(Extracted) imgToTextValue;

  final void Function(File) image;

  @override
  _ImagePickerState createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ImagePicker> {
  final img.ImagePicker _imagePicker = img.ImagePicker();
  File _image;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: <Widget>[
            Text(
              widget.title,
              style: TextStyle(
                  fontSize: 12.0,
                  color: ColorBase.veryDarkGrey,
                  fontFamily: FontsFamily.roboto,
                  fontWeight: FontWeight.bold),
            ),
            widget.isRequired
                ? Text(
                    Dictionary.requiredForm,
                    style: TextStyle(
                        fontSize: 10.0,
                        color: Colors.green,
                        fontFamily: FontsFamily.roboto,
                        fontWeight: FontWeight.bold),
                  )
                : Container(),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        InkWell(
          onTap: () async {
            _image = await _openImagePicker();
            if (_image != null) {
              if (widget.image != null) {
                widget.image(_image);
              }
              if (widget.imgToTextValue != null) {
                final extracted = await OCRHelper(image: _image).extract;
                widget.imgToTextValue(extracted);
              }
              setState(() {});
            }
          },
          child: DottedBorder(
            borderType: BorderType.RRect,
            radius: Radius.circular(8),
            dashPattern: const <double>[5, 3],
            padding: EdgeInsets.zero,
            color: ColorBase.netralGrey,
            child: AspectRatio(
              aspectRatio: 21 / 9,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                child: Container(
                  color: ColorBase.grey,
                  child: _image == null
                      ? Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_outlined,
                              color: ColorBase.netralGrey,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(Dictionary.uploadPhoto),
                          ],
                        )
                      : Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: double.infinity,
                              child: Image.file(
                                _image,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: Dimens.padding,
                              right: Dimens.padding,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _image = null;
                                  });
                                },
                                child: Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                              ),
                            )
                          ],
                        ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Future<File> _openImagePicker() async {
    img.PickedFile pickedFile;

    await showWidgetBottomSheet(
        context: context,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Dictionary.uploadPhoto,
              style: TextStyle(
                fontFamily: FontsFamily.roboto,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: Dimens.padding),
            Text(
              Dictionary.btsImgPickerDescription,
              style: TextStyle(
                fontFamily: FontsFamily.roboto,
              ),
            ),
            SizedBox(height: 24.0),
            RoundedButton(
              title: Dictionary.pickFromGallery,
              textStyle: TextStyle(
                  fontFamily: FontsFamily.lato,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              color: ColorBase.green,
              elevation: 0.0,
              onPressed: () async {
                pickedFile =
                    await _imagePicker.getImage(source: ImageSource.gallery);
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 16),
            Row(
              children: <Widget>[
                Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimens.borderRadius),
                  child: Text(Dictionary.or),
                ),
                Expanded(child: Divider()),
              ],
            ),
            SizedBox(height: 16),
            RoundedButton(
              title: Dictionary.pickFromCamera,
              textStyle: TextStyle(
                  fontFamily: FontsFamily.lato,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              color: ColorBase.green,
              elevation: 0.0,
              onPressed: () async {
                pickedFile =
                    await _imagePicker.getImage(source: ImageSource.camera);
              },
            ),
          ],
        ));

    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      print('No image selected.');
      return null;
    }
  }
}
