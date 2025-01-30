import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../providers/image_provider.dart';
import '../services/image_service.dart';
import '../controllers/image_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ImageController _imageController;
  final ImagePicker _picker = ImagePicker();

  // Add temporary path generation
  Future<String> _generateOutputPath() async {
    final dir = await getTemporaryDirectory();
    return '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
  }

  @override
  void initState() {
    super.initState();
    final service = ImageService();
    final provider = Provider.of<ImageAppProvider>(context, listen: false);
    _imageController = ImageController(service, provider);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ImageAppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('EverPixel Demo'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (provider.selectedImagePath != null)
                Image.file(
                    File(provider.selectedImagePath!)), // Update to File image

              ElevatedButton(
                onPressed: () async {
                  final XFile? image = await _picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 80,
                  );
                  if (image != null) {
                    provider.setSelectedImage(image.path);
                  }
                },
                child: const Text('Select From Gallery'),
              ),

              ElevatedButton(
                onPressed:
                    provider.isLoading ? null : _imageController.convertToGray,
                child: const Text('Grayscale'),
              ),

              ElevatedButton(
                onPressed: () {
                  final version = _imageController.getOpenCVVersion();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('OpenCV $version')),
                  );
                },
                child: const Text('Get Version'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
