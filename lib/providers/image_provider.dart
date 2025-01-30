import 'package:flutter/material.dart';

/// This provider holds the state regarding the currently selected image
/// and any filter that’s being applied.
class ImageAppProvider extends ChangeNotifier {
  String? _selectedImagePath;
  bool _isLoading = false;
  List<String> _imageVersions = [];
  bool _showComparison = false;

  String? get selectedImagePath => _selectedImagePath;
  bool get isLoading => _isLoading;
  List<String> get imageVersions => _imageVersions;
  bool get showComparison => _showComparison;
  String? get previousVersion => _imageVersions.length > 1
      ? _imageVersions[_imageVersions.length - 2]
      : null;

  double beforeAfterValue = 0.5;

  void setSelectedImage(String path) {
    _selectedImagePath = path;
    if (_imageVersions.isEmpty) {
      _imageVersions.add(path);
    }
    notifyListeners();
  }

  void changeBeforeAfterValue(double value) {
    beforeAfterValue = value;
    notifyListeners();
  }

  void addNewVersion(String path) {
    _imageVersions.add(path);
    _selectedImagePath = path;
    notifyListeners();
  }

  void rollbackToPreviousVersion() {
    if (_imageVersions.length > 1) {
      _imageVersions.removeLast();
      _selectedImagePath = _imageVersions.last;
      notifyListeners();
    }
  }

  void setShowComparison(bool value) {
    _showComparison = value;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
