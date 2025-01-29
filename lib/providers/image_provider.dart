import 'package:flutter/material.dart';

/// This provider holds the state regarding the currently selected image
/// and any filter that’s being applied.
class ImageAppProvider extends ChangeNotifier {
  String? _selectedImagePath;
  bool _isLoading = false;

  String? get selectedImagePath => _selectedImagePath;
  bool get isLoading => _isLoading;

  void setSelectedImage(String path) {
    _selectedImagePath = path;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
