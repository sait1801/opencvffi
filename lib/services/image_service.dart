import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:http/http.dart' as http;

class ImageService {
  final DynamicLibrary _lib;
  static const String baseUrl = 'http://192.168.0.5:5000';

  // Existing FFI function pointers
  late final Pointer<Utf8> Function() _getOpenCVVersion;
  late final void Function(Pointer<Utf8>, Pointer<Utf8>)
      _convertImageToGrayImage;
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
    // Initialize existing FFI functions
    _getOpenCVVersion = _lib
        .lookup<NativeFunction<Pointer<Utf8> Function()>>('getOpenCVVersion')
        .asFunction();
    _convertImageToGrayImage = _lib
        .lookup<NativeFunction<Void Function(Pointer<Utf8>, Pointer<Utf8>)>>(
            'convertImageToGrayImage')
        .asFunction();
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

  // Existing FFI methods
  String getOpenCVVersion() {
    return _getOpenCVVersion().cast<Utf8>().toDartString();
  }

  void convertImageToGrayImage(String inputPath, String outputPath) {
    _convertImageToGrayImage(
        inputPath.toNativeUtf8(), outputPath.toNativeUtf8());
  }

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

  // New backend API methods
  Future<String?> processImage(String imagePath, String operation,
      {Map<String, dynamic>? params}) async {
    try {
      final File imageFile = File(imagePath);
      final List<int> imageBytes = await imageFile.readAsBytes();
      final String base64Image = base64Encode(imageBytes);

      final Map<String, dynamic> requestBody = {
        'image': base64Image,
        'operation': operation,
        if (params != null) 'params': params,
      };

      final client = http.Client();
      try {
        final response = await client
            .post(
              Uri.parse('$baseUrl/process_image'),
              headers: {
                'Content-Type': 'application/json',
                "Keep-Alive": "timeout=5, max=1",
                'Accept': 'application/json',
              },
              body: jsonEncode(requestBody),
            )
            .timeout(const Duration(seconds: 30));

        if (response.statusCode == 200) {
          // Convert response bytes to string then decode JSON
          final String responseString = utf8.decode(response.bodyBytes);
          final Map<String, dynamic> responseData = jsonDecode(responseString);

          if (responseData['status'] == 'success') {
            return responseData['processed_image'];
          } else {
            throw Exception('Processing failed: ${responseData['error']}');
          }
        } else {
          throw Exception('Failed to process image: ${response.statusCode}');
        }
      } finally {
        client.close();
      }
    } catch (e) {
      print('Error processing image: $e');
      return null;
    }
  }

  // Backend API convenience methods
  Future<String?> applyEdgeDetectionBackend(String imagePath) async {
    return processImage(imagePath, 'edge_detection');
  }

  Future<String?> applyGaussianBlurBackend(String imagePath,
      {int kernelSize = 5}) async {
    return processImage(imagePath, 'gaussian_blur',
        params: {'kernel_size': kernelSize});
  }

  Future<String?> applySharpenBackend(String imagePath) async {
    return processImage(imagePath, 'sharpen');
  }

  Future<String?> convertToGrayscaleBackend(String imagePath) async {
    return processImage(imagePath, 'grayscale');
  }

  Future<String?> applyMedianBlurBackend(String imagePath,
      {int kernelSize = 3}) async {
    return processImage(imagePath, 'median_blur',
        params: {'kernel_size': kernelSize});
  }

  Future<String?> applySobelEdgeBackend(String imagePath) async {
    return processImage(imagePath, 'sobel_edge');
  }

  // Helper method to save base64 image
  Future<void> saveBase64Image(String base64String, String outputPath) async {
    try {
      final bytes = base64Decode(base64String);
      await File(outputPath).writeAsBytes(bytes);
    } catch (e) {
      print('Error saving image: $e');
    }
  }
}
