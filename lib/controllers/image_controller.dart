import 'package:opencvffi/providers/image_provider.dart';
import 'package:opencvffi/services/image_service.dart';
import 'package:path_provider/path_provider.dart';

class ImageController {
  final ImageService _imageService;
  final ImageAppProvider _imageAppProvider;

  ImageController(this._imageService, this._imageAppProvider);

  Future<void> convertToGray() async {
    final input = _imageAppProvider.selectedImagePath;
    if (input == null) return;

    _imageAppProvider.setLoading(true);

    final output = await _generateOutputPath();
    _imageService.convertImageToGrayImage(input, output);
    _imageAppProvider.addNewVersion(output);

    // Store the current image as previous version for comparison
    _imageAppProvider.setTempPreview(output);
    _imageAppProvider.setShowComparison(true);
    _imageAppProvider.setLoading(false);
  }

  // New image processing methods
  Future<void> applyGaussianBlur({int kernelSize = 5}) async {
    final input = _imageAppProvider.selectedImagePath;
    if (input == null) return;

    _imageAppProvider.setLoading(true);

    final output = await _generateOutputPath();
    _imageService.applyGaussianBlur(input, output, kernelSize);
    _imageAppProvider.addNewVersion(output);

    _imageAppProvider.setTempPreview(output);
    _imageAppProvider.setShowComparison(true);
    _imageAppProvider.setLoading(false);
  }

  Future<void> applySharpen() async {
    final input = _imageAppProvider.selectedImagePath;
    if (input == null) return;

    _imageAppProvider.setLoading(true);

    final output = await _generateOutputPath();
    _imageService.applySharpen(input, output);
    _imageAppProvider.addNewVersion(output);

    _imageAppProvider.setTempPreview(output);
    _imageAppProvider.setShowComparison(true);
    _imageAppProvider.setLoading(false);
  }

  Future<void> detectEdges() async {
    final input = _imageAppProvider.selectedImagePath;
    if (input == null) return;

    _imageAppProvider.setLoading(true);

    final output = await _generateOutputPath();
    _imageService.detectEdges(input, output);
    _imageAppProvider.addNewVersion(output);

    _imageAppProvider.setTempPreview(output);
    _imageAppProvider.setShowComparison(true);
    _imageAppProvider.setLoading(false);
  }

  Future<void> applyMedianBlur({int kernelSize = 3}) async {
    final input = _imageAppProvider.selectedImagePath;
    if (input == null) return;

    _imageAppProvider.setLoading(true);

    final output = await _generateOutputPath();
    _imageService.applyMedianBlur(input, output, kernelSize);
    _imageAppProvider.addNewVersion(output);

    _imageAppProvider.setTempPreview(output);
    _imageAppProvider.setShowComparison(true);
    _imageAppProvider.setLoading(false);
  }

  Future<void> applySobelEdge() async {
    final input = _imageAppProvider.selectedImagePath;
    if (input == null) return;

    _imageAppProvider.setLoading(true);

    final output = await _generateOutputPath();
    _imageService.applySobelEdge(input, output);
    _imageAppProvider.addNewVersion(output);

    _imageAppProvider.setTempPreview(output);
    _imageAppProvider.setShowComparison(true);
    _imageAppProvider.setLoading(false);
  }

  void acceptNewVersion() {
    if (_imageAppProvider.selectedImagePath != null) {
      _imageAppProvider.addNewVersion(_imageAppProvider.selectedImagePath!);
      _imageAppProvider.setShowComparison(false);
    }
  }

  void rollback() {
    _imageAppProvider.rollbackToPreviousVersion();
  }

  String getOpenCVVersion() => _imageService.getOpenCVVersion();

  Future<String> _generateOutputPath() async {
    final dir = await getTemporaryDirectory();
    return '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
  }
}
