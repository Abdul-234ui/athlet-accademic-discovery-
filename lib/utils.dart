import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

ImageProvider? getProfileImageProvider(String? photoURL) {
  if (photoURL == null || photoURL.isEmpty) return null;
  if (kIsWeb || photoURL.startsWith('http')) {
    return NetworkImage(photoURL);
  } else {
    return FileImage(File(photoURL));
  }
}
