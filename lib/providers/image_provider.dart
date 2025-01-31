import 'package:flutter/material.dart';

class ImageAppProvider extends ChangeNotifier {
  String? _selectedImagePath;
  bool _isLoading = false;
  List<String> _imageVersions = [];
  bool _showComparison = false;
  double beforeAfterValue = 0.5;

  String? get selectedImagePath => _selectedImagePath;
  bool get isLoading => _isLoading;
  List<String> get imageVersions => _imageVersions;
  bool get showComparison => _showComparison;
  String? get previousVersion => _imageVersions.length > 1
      ? _imageVersions[_imageVersions.length - 2]
      : null;

  void setSelectedImage(String path) {
    _selectedImagePath = path;
    beforeAfterValue = 0.5;
    _imageVersions = [path];
    _showComparison = false;
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

  void setTempPreview(String path) {
    _selectedImagePath = path;
    notifyListeners();
  }

  void rollbackToPreviousVersion() {
    if (_imageVersions.length > 1) {
      _imageVersions.removeLast();
      _selectedImagePath = _imageVersions.last;
      print(_selectedImagePath);
      _showComparison = false;
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
