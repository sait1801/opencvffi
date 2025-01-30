import 'package:opencvffi/providers/image_provider.dart';
import 'package:opencvffi/services/image_service.dart';
import 'package:path_provider/path_provider.dart';

/// The controller orchestrates between the services and providers.
/// The UI (screens) will call methods from this controller for business logic.
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

    _imageAppProvider.setSelectedImage(output);
    _imageAppProvider.setLoading(false);
  }

  String getOpenCVVersion() => _imageService.getOpenCVVersion();

  Future<String> _generateOutputPath() async {
    final dir = await getTemporaryDirectory();
    return '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
  }
}
