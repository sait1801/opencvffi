import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

class ImageService {
  final DynamicLibrary _lib;
  late final Pointer<Utf8> Function() _getOpenCVVersion;
  late final void Function(Pointer<Utf8>, Pointer<Utf8>)
      _convertImageToGrayImage;

  ImageService()
      : _lib = Platform.isAndroid
            ? DynamicLibrary.open('libmy_functions.so')
            : DynamicLibrary.process() {
    _getOpenCVVersion = _lib
        .lookup<NativeFunction<Pointer<Utf8> Function()>>('getOpenCVVersion')
        .asFunction();
    _convertImageToGrayImage = _lib
        .lookup<NativeFunction<Void Function(Pointer<Utf8>, Pointer<Utf8>)>>(
            'convertImageToGrayImage')
        .asFunction();
  }

  String getOpenCVVersion() {
    return _getOpenCVVersion().cast<Utf8>().toDartString();
  }

  void convertImageToGrayImage(String inputPath, String outputPath) {
    _convertImageToGrayImage(
        inputPath.toNativeUtf8(), outputPath.toNativeUtf8());
  }
}
