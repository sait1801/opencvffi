import 'dart:io';

import 'package:before_after/before_after.dart';
import 'package:flutter/material.dart';
import 'package:opencvffi/providers/image_provider.dart';

Widget buildImageDisplay(
    {required ImageAppProvider provider, required BuildContext context}) {
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
    height: MediaQuery.of(context).size.height * 0.7, // Height constraint added
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
