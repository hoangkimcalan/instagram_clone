import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _file = await _imagePicker.pickImage(source: source);

  if (_file != null) {
    return await _file.readAsBytes();
  }
  log('No image selected');
}

pickImageGallery(ImageSource source) async {
  final ImagePicker picker = ImagePicker();

  final List<XFile?> images = await picker.pickMultiImage(imageQuality: 70);

  if (images.isNotEmpty) {
    return images;
  }

  log('No image selected');
}

showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}
