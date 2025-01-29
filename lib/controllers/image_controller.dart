import 'package:opencvffi/providers/image_provider.dart';
import 'package:opencvffi/services/image_service.dart';

/// The controller orchestrates between the services and providers.
/// The UI (screens) will call methods from this controller for business logic.
class ImageController {
  final ImageService _imageService;
  final ImageAppProvider _imageAppProvider;

  ImageController(this._imageService, this._imageAppProvider);

  /// Example method to show how the UI calls the controller to apply a filter.
  Future<void> applyFilter(String filterType) async {
    final currentPath = _imageAppProvider.selectedImagePath;
    if (currentPath == null) return;

    _imageAppProvider.setLoading(true);

    // Apply the filter using the service
    final resultPath =
        await _imageService.applyMockFilter(currentPath, filterType);

    // Save the new state
    _imageAppProvider.setSelectedImage(resultPath);

    _imageAppProvider.setLoading(false);
  }
}
