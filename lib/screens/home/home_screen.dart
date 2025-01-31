import 'dart:io';
import 'package:before_after/before_after.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:opencvffi/screens/home/widgets/button_widget.dart';
import 'package:opencvffi/screens/home/widgets/image_display_widget.dart';
import '../../providers/image_provider.dart';
import '../../services/image_service.dart';
import '../../controllers/image_controller.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ImageController _imageController;
  final ImagePicker _picker = ImagePicker();

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
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: provider.imageVersions.length > 1
            ? IconButton(
                icon: const Icon(
                  Icons.replay_rounded,
                  color: Color(0xFF2196F3),
                  size: 28,
                ),
                onPressed: _imageController.rollback,
              )
            : null,
        title: const Text(
          'EverPixel Demo',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: height * 0.6,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  buildImageDisplay(provider: provider, context: context),
                ],
              ),
            ),
          ),
          Container(
            height: height * 0.3,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (provider.showComparison) ...[
                    buildStylizedButton(
                      onPressed: _imageController.acceptNewVersion,
                      text: 'Apply Changes',
                    ),
                    buildStylizedButton(
                      onPressed: _imageController.rollback,
                      text: 'Cancel',
                      isPrimary: false,
                    ),
                  ] else ...[
                    buildStylizedButton(
                      onPressed: () async {
                        final XFile? image = await _picker.pickImage(
                          source: ImageSource.gallery,
                          imageQuality: 80,
                        );
                        if (image != null) {
                          provider.setSelectedImage(image.path);
                        }
                      },
                      text: 'Select From Gallery',
                    ),
                    buildStylizedButton(
                      onPressed: provider.isLoading
                          ? null
                          : _imageController.convertToGray,
                      text: 'Apply Grayscale',
                      isPrimary: false,
                    ),
                    buildStylizedButton(
                      onPressed: provider.isLoading
                          ? null
                          : () =>
                              _imageController.applyGaussianBlur(kernelSize: 5),
                      text: 'Apply Blur',
                      isPrimary: false,
                    ),
                    buildStylizedButton(
                      onPressed: provider.isLoading
                          ? null
                          : _imageController.applySharpen,
                      text: 'Sharpen Image',
                      isPrimary: false,
                    ),
                    buildStylizedButton(
                      onPressed: provider.isLoading
                          ? null
                          : _imageController.detectEdges,
                      text: 'Detect Edges',
                      isPrimary: false,
                    ),
                    buildStylizedButton(
                      onPressed: provider.isLoading
                          ? null
                          : () =>
                              _imageController.applyMedianBlur(kernelSize: 3),
                      text: 'Median Blur',
                      isPrimary: false,
                    ),
                    buildStylizedButton(
                      onPressed: provider.isLoading
                          ? null
                          : _imageController.applySobelEdge,
                      text: 'Sobel Edge',
                      isPrimary: false,
                    ),
                    buildStylizedButton(
                      onPressed: provider.isLoading
                          ? null
                          : _imageController.convertToGrayBackend,
                      text: 'Grayscale w/ API',
                      isPrimary: false,
                    ),
                    buildStylizedButton(
                      onPressed: provider.isLoading
                          ? null
                          : _imageController.detectEdgesBackend,
                      text: 'Detect Edges w/ API',
                      isPrimary: false,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
