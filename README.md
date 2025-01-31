# EverPixel - Flutter Image Processing App

## Overview

EverPixel is a cross-platform image processing application built with Flutter and OpenCV. The app provides real-time image processing capabilities with an intuitive before/after comparison interface.

## Project Structure

```bash
├── lib/
│ ├── controllers/
│ │ └── image_controller.dart # Image processing logic controller
│ ├── providers/
│ │ └── image_provider.dart # State management
│ ├── screens/ │ │ └── home_screen.dart # Main UI screen
│ ├── services/
│ │ └── image_service.dart # Native code bridge
│ └── main.dart # Entry point
├── open_cv/
│ └── my_functions.cpp # Native OpenCV implementations
```

## Features

- Image selection from gallery
- Real-time image processing
- Before/After comparison slider
- Multiple processing effects:
  - Grayscale conversion
  - Gaussian blur
  - Image sharpening
  - Edge detection (Canny)
  - Median blur
  - Sobel edge detection

## Setup Guide

### Prerequisites

- Flutter SDK (latest stable)
- OpenCV 4.x
- C++ compiler
- CMake

### Installation Steps

1. **Clone Repository**

```bash
git clone https://github.com/yourusername/everpixel.git
cd everpixel
```

2. **Package Installation**

```bash
flutter pub get
```

3. **Run The APP**

```bash
flutter run
```

## Code Organization

controllers/: Business logic and state management
providers/: App-wide state management using Provider
screens/: UI components and screens
services/: Platform integration and native code bridges
open_cv/: Native OpenCV implementations
