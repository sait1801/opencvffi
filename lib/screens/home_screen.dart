import 'dart:io';
import 'package:before_after/before_after.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/image_provider.dart';
import '../services/image_service.dart';
import '../controllers/image_controller.dart';
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

  Widget _buildStylizedButton({
    required VoidCallback? onPressed,
    required String text,
    bool isPrimary = true,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? const Color(0xFF2196F3) : Colors.white,
          foregroundColor: isPrimary ? Colors.white : const Color(0xFF2196F3),
          elevation: isPrimary ? 3 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: BorderSide(
              color: isPrimary ? Colors.transparent : const Color(0xFF2196F3),
              width: 2,
            ),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isPrimary ? Colors.white : const Color(0xFF2196F3),
          ),
        ),
      ),
    );
  }

  Widget _buildImageDisplay(ImageAppProvider provider) {
    if (provider.selectedImagePath == null) {
      return const Center(
        child: Text(
          'Select an image to start',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(16),
      height:
          MediaQuery.of(context).size.height * 0.7, // Height constraint added
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: provider.showComparison && provider.previousVersion != null
            ? BeforeAfter(
                value: provider.beforeAfterValue,
                thumbColor: Colors.white,
                overlayColor: WidgetStateProperty.all(Colors.white24),
                direction: SliderDirection.horizontal,
                before: Image.file(
                  File(provider.previousVersion!),
                  fit: BoxFit.cover,
                ),
                after: Image.file(
                  File(provider.selectedImagePath!),
                  fit: BoxFit.cover,
                ),
                onValueChanged: (value) {
                  provider.changeBeforeAfterValue(value);
                },
              )
            : Image.file(
                File(provider.selectedImagePath!),
                fit: BoxFit.cover,
              ),
      ),
    );
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
                  _buildImageDisplay(provider),
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
                    _buildStylizedButton(
                      onPressed: _imageController.acceptNewVersion,
                      text: 'Apply Changes',
                    ),
                    _buildStylizedButton(
                      onPressed: _imageController.rollback,
                      text: 'Cancel',
                      isPrimary: false,
                    ),
                  ] else ...[
                    _buildStylizedButton(
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
                    _buildStylizedButton(
                      onPressed: provider.isLoading
                          ? null
                          : _imageController.convertToGray,
                      text: 'Apply Grayscale',
                      isPrimary: false,
                    ),
                    _buildStylizedButton(
                      onPressed: provider.isLoading
                          ? null
                          : () =>
                              _imageController.applyGaussianBlur(kernelSize: 5),
                      text: 'Apply Blur',
                      isPrimary: false,
                    ),
                    _buildStylizedButton(
                      onPressed: provider.isLoading
                          ? null
                          : _imageController.applySharpen,
                      text: 'Sharpen Image',
                      isPrimary: false,
                    ),
                    _buildStylizedButton(
                      onPressed: provider.isLoading
                          ? null
                          : _imageController.detectEdges,
                      text: 'Detect Edges',
                      isPrimary: false,
                    ),
                    _buildStylizedButton(
                      onPressed: provider.isLoading
                          ? null
                          : () =>
                              _imageController.applyMedianBlur(kernelSize: 3),
                      text: 'Median Blur',
                      isPrimary: false,
                    ),
                    _buildStylizedButton(
                      onPressed: provider.isLoading
                          ? null
                          : _imageController.applySobelEdge,
                      text: 'Sobel Edge',
                      isPrimary: false,
                    ),
                    _buildStylizedButton(
                      onPressed: provider.isLoading
                          ? null
                          : _imageController.convertToGrayBackend,
                      text: 'Grayscale w/ API',
                      isPrimary: false,
                    ),
                    _buildStylizedButton(
                      onPressed: provider.isLoading
                          ? null
                          : () => _imageController.applyGaussianBlurBackend(
                              kernelSize: 5),
                      text: 'Blur w/ API',
                      isPrimary: false,
                    ),
                    _buildStylizedButton(
                      onPressed: provider.isLoading
                          ? null
                          : _imageController.applySharpenBackend,
                      text: 'Sharpen w/ API',
                      isPrimary: false,
                    ),
                    _buildStylizedButton(
                      onPressed: provider.isLoading
                          ? null
                          : _imageController.detectEdgesBackend,
                      text: 'Detect Edges w/ API',
                      isPrimary: false,
                    ),
                    _buildStylizedButton(
                      onPressed: provider.isLoading
                          ? null
                          : () => _imageController.applyMedianBlurBackend(
                              kernelSize: 3),
                      text: 'Median Blur w/ API',
                      isPrimary: false,
                    ),
                    _buildStylizedButton(
                      onPressed: provider.isLoading
                          ? null
                          : _imageController.applySobelEdgeBackend,
                      text: 'Sobel Edge w/ API',
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
