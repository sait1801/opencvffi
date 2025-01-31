import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

class ImageService {
  final DynamicLibrary _lib;

  // Existing function pointers
  late final Pointer<Utf8> Function() _getOpenCVVersion;
  late final void Function(Pointer<Utf8>, Pointer<Utf8>)
      _convertImageToGrayImage;

  // New function pointers
  late final void Function(Pointer<Utf8>, Pointer<Utf8>, int)
      _applyGaussianBlur;
  late final void Function(Pointer<Utf8>, Pointer<Utf8>) _applySharpen;
  late final void Function(Pointer<Utf8>, Pointer<Utf8>) _detectEdges;
  late final void Function(Pointer<Utf8>, Pointer<Utf8>, int) _applyMedianBlur;
  late final void Function(Pointer<Utf8>, Pointer<Utf8>) _applySobelEdge;

  ImageService()
      : _lib = Platform.isAndroid
            ? DynamicLibrary.open('libmy_functions.so')
            : DynamicLibrary.process() {
    // Initialize existing functions
    _getOpenCVVersion = _lib
        .lookup<NativeFunction<Pointer<Utf8> Function()>>('getOpenCVVersion')
        .asFunction();
    _convertImageToGrayImage = _lib
        .lookup<NativeFunction<Void Function(Pointer<Utf8>, Pointer<Utf8>)>>(
            'convertImageToGrayImage')
        .asFunction();

    // Initialize new functions
    _applyGaussianBlur = _lib
        .lookup<
            NativeFunction<
                Void Function(
                    Pointer<Utf8>, Pointer<Utf8>, Int32)>>('applyGaussianBlur')
        .asFunction();

    _applySharpen = _lib
        .lookup<NativeFunction<Void Function(Pointer<Utf8>, Pointer<Utf8>)>>(
            'applySharpen')
        .asFunction();

    _detectEdges = _lib
        .lookup<NativeFunction<Void Function(Pointer<Utf8>, Pointer<Utf8>)>>(
            'detectEdges')
        .asFunction();

    _applyMedianBlur = _lib
        .lookup<
            NativeFunction<
                Void Function(
                    Pointer<Utf8>, Pointer<Utf8>, Int32)>>('applyMedianBlur')
        .asFunction();

    _applySobelEdge = _lib
        .lookup<NativeFunction<Void Function(Pointer<Utf8>, Pointer<Utf8>)>>(
            'applySobelEdge')
        .asFunction();
  }

  // Existing methods
  String getOpenCVVersion() {
    return _getOpenCVVersion().cast<Utf8>().toDartString();
  }

  void convertImageToGrayImage(String inputPath, String outputPath) {
    _convertImageToGrayImage(
        inputPath.toNativeUtf8(), outputPath.toNativeUtf8());
  }

  // New methods
  void applyGaussianBlur(String inputPath, String outputPath, int kernelSize) {
    _applyGaussianBlur(
        inputPath.toNativeUtf8(), outputPath.toNativeUtf8(), kernelSize);
  }

  void applySharpen(String inputPath, String outputPath) {
    _applySharpen(inputPath.toNativeUtf8(), outputPath.toNativeUtf8());
  }

  void detectEdges(String inputPath, String outputPath) {
    _detectEdges(inputPath.toNativeUtf8(), outputPath.toNativeUtf8());
  }

  void applyMedianBlur(String inputPath, String outputPath, int kernelSize) {
    _applyMedianBlur(
        inputPath.toNativeUtf8(), outputPath.toNativeUtf8(), kernelSize);
  }

  void applySobelEdge(String inputPath, String outputPath) {
    _applySobelEdge(inputPath.toNativeUtf8(), outputPath.toNativeUtf8());
  }
}
