import 'package:flutter/material.dart';
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
              // Display the selected image (mock display here)
              if (provider.selectedImagePath != null)
                Image.asset(provider.selectedImagePath!),
              const SizedBox(height: 20),

              // Button to simulate selecting an image
              ElevatedButton(
                onPressed: () {
                  // For this demo, we pretend we select an image from the gallery.
                  provider.setSelectedImage("assets/images/baydirman.jpeg");
                },
                child: const Text('Select Mock Image'),
              ),
              const SizedBox(height: 20),

              // Buttons to apply filters
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: provider.isLoading
                        ? null
                        : () => _imageController.applyFilter("grayscale"),
                    child: const Text('Apply Grayscale'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: provider.isLoading
                        ? null
                        : () => _imageController.applyFilter("blur"),
                    child: const Text('Apply Blur'),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Loading indicator
              if (provider.isLoading)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
