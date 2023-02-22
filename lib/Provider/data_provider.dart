import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saver_gallery/saver_gallery.dart';
import '../Models/card_ob.dart';
import '../Models/group_ob.dart';
import '../objectbox.g.dart';

class DataProvider with ChangeNotifier {
  File? _selectedImg;
  File? get selectedImg => _selectedImg;

  String? _base64Img;
  String? get base64Img => _base64Img;
  Uint8List convertFromBase64(String base64string) {
    var imgbyte = base64Decode(base64string);
    return imgbyte;
  }

  convertToBase64({required File imgFile}) async {
    Uint8List bytes = await imgFile.readAsBytes();
    _base64Img = base64Encode(bytes);
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        imageQuality: 90,
      );
      if (image == null) return;
      final img = File(image.path);
      Directory? tempDir = await getExternalStorageDirectory();
      String tempPath = tempDir!.path;
      final String filePath = '$tempPath/image.png';
      await img.copy(filePath);
      await SaverGallery.saveFile(filePath);

      _selectedImg = img;

      if (selectedImg == null) return;
      convertToBase64(imgFile: selectedImg!);
      notifyListeners();
    } on PlatformException catch (e) {
      print('failed $e');
    }
  }

  void onSave(String description, TextEditingController textController, Group group, Store store) async {
    // final description = textController.text.trim();
    if (description.isNotEmpty) {
      textController.clear();

      final task = CardModel(
        description: description,
        image: base64Img,
      );
      task.group.target = group;
      store.box<CardModel>().put(task);
      if (selectedImg == null) return;

      _selectedImg = null;
      notifyListeners();

      //_reloadTasks();
    }
  }
}
