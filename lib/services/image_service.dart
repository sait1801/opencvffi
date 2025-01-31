import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:http/http.dart' as http;

class ImageService {
  final DynamicLibrary _lib;
  static const String baseUrl = 'http://192.168.0.5:5000';

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

  // Backend versions of the functions
  Future<String> convertImageToGrayImageBackend(String inputPath) async {
    final bytes = await File(inputPath).readAsBytes();
    final base64Image = base64Encode(bytes);

    print("Sending request to backend");

    final response = await http.post(
      Uri.parse('$baseUrl/process_image'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'image': base64Image, 'operation': 'grayscale'}),
    );

    print("GOT  Response from backend: ${response.statusCode}");

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['processed_image'];
    }
    throw Exception('Failed to process image');
  }

  Future<String> applyGaussianBlurBackend(
      String inputPath, int kernelSize) async {
    final bytes = await File(inputPath).readAsBytes();
    final base64Image = base64Encode(bytes);

    final response = await http.post(
      Uri.parse('$baseUrl/process_image'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'image': base64Image,
        'operation': 'gaussian_blur',
        'params': {'kernel_size': kernelSize}
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['processed_image'];
    }
    throw Exception('Failed to process image');
  }

  Future<String> applySharpenBackend(String inputPath) async {
    final bytes = await File(inputPath).readAsBytes();
    final base64Image = base64Encode(bytes);

    final response = await http.post(
      Uri.parse('$baseUrl/process_image'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'image': base64Image, 'operation': 'sharpen'}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['processed_image'];
    }
    throw Exception('Failed to process image');
  }

  Future<String> detectEdgesBackend(String inputPath) async {
    final bytes = await File(inputPath).readAsBytes();
    final base64Image = base64Encode(bytes);

    final response = await http.post(
      Uri.parse('$baseUrl/process_image'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'image': base64Image, 'operation': 'edge_detection'}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['processed_image'];
    }
    throw Exception('Failed to process image');
  }

  Future<String> applyMedianBlurBackend(
      String inputPath, int kernelSize) async {
    final bytes = await File(inputPath).readAsBytes();
    final base64Image = base64Encode(bytes);

    final response = await http.post(
      Uri.parse('$baseUrl/process_image'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'image': base64Image,
        'operation': 'median_blur',
        'params': {'kernel_size': kernelSize}
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['processed_image'];
    }
    throw Exception('Failed to process image');
  }

  Future<String> applySobelEdgeBackend(String inputPath) async {
    final bytes = await File(inputPath).readAsBytes();
    final base64Image = base64Encode(bytes);

    final response = await http.post(
      Uri.parse('$baseUrl/process_image'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'image': base64Image, 'operation': 'sobel_edge'}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['processed_image'];
    }
    throw Exception('Failed to process image');
  }
}
