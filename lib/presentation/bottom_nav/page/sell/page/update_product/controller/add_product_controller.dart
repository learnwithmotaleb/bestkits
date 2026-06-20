import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddProductController extends GetxController {
  final _picker = ImagePicker();
  final RxList<File> pickedImages = <File>[].obs;

  Future<void> pickImages() async {
    final List<XFile> result = await _picker.pickMultiImage(imageQuality: 80);
    if (result.isEmpty) return;
    for (final xFile in result) {
      if (pickedImages.length < 6) {
        pickedImages.add(File(xFile.path));
      }
    }
  }

  void removePickedImage(int index) {
    if (index >= 0 && index < pickedImages.length) {
      pickedImages.removeAt(index);
    }
  }
}
