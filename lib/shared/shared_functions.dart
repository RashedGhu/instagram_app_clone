import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../cash/cash_helper.dart';
import '../util/global_variables.dart';

Future pickImage({required ImageSource source}) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);
  if (_file != null) {
    return await _file.readAsBytes();
  }
}

// adding image to firebase storage  :

Future<String> uploadImageToFireBaseStorage({
  required String childName,
  required Uint8List? file,
  required bool isPostImage,
}) async {
  // now we are going to create location to our firebase storage
  Reference _ref = GlobalV.fireBaseStorage
      .ref()
      .child(childName)
      .child(GlobalV.auth.currentUser!.uid);
  // ref() method stands for refrences s its the refrence or the pointer at the file we have uploaded  .
  // the first child() is to create a new folder in the firebase storage  . wich is 'profilePics'
  // the second child is to make the uploaded photo name is  the uid   .

  if (isPostImage) {
    String id = Uuid().v1();
    _ref = GlobalV.fireBaseStorage
        .ref()
        .child(childName)
        .child(GlobalV.auth.currentUser!.uid)
        .child(id);
    // we did this so at the end the image will be stored as an user id and it has its own id .
  }

  UploadTask _uploadTask = _ref.putData(file!);

  TaskSnapshot snapShot = await _uploadTask;
  String downloadUrl = await snapShot.ref.getDownloadURL();
  return downloadUrl;
}

double getDeviceWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double getDeviceHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

void showSnakBar({
  required BuildContext context,
  required String text,
  Color textColor = Colors.black,
  Color? backGroundColor = Colors.grey,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        style: TextStyle(color: textColor),
      ),
      duration: Duration(seconds: 3),
      backgroundColor: backGroundColor,
    ),
  );
}

String timeAgoSinceNow({required int time}) {
  DateTime notificationDate = DateTime.fromMillisecondsSinceEpoch(time);
  final date2 = DateTime.now();
  final diff = date2.difference(notificationDate);

  if (diff.inDays > 8)
    return DateFormat('dd-MM-yyy HH:mm:ss').format(notificationDate);
  else if ((diff.inDays / 7).floor() >= 1)
    return 'last week';
  else if (diff.inDays >= 2)
    return '${diff.inDays} days ago';
  else if (diff.inDays >= 1)
    return '1 day ago';
  else if (diff.inHours >= 2)
    return '${diff.inHours} h ago';
  else if (diff.inHours >= 1)
    return '1 hour ago';
  else if (diff.inMinutes >= 2)
    return '${diff.inMinutes} min ago';
  else if (diff.inMinutes >= 1)
    return '1 minute ago';
  else if (diff.inSeconds >= 3)
    return '${diff.inSeconds} sec ago';
  else
    return 'just now';
}

bool isSameDay({required int time}) {
  DateTime notificationDate = DateTime.fromMillisecondsSinceEpoch(time);
  final date2 = DateTime.now();
  final diff = date2.difference(notificationDate);

  if (diff.inDays > 0) {
    return false;
  } else
    return true;
}

Widget customProgressIndecator() {
  final bool isCurrentModeDark =
      CashHelper.getSavedCashData(key: 'userLatestThemeMode');
  return Center(
    child: isCurrentModeDark
        ? CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 0.3,
          )
        : CircularProgressIndicator(
            color: Colors.grey[600],
            strokeWidth: 0.6,
          ),
  );
}
