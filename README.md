# EverPixel - Flutter Image Processing App

## Overview

EverPixel is a cross-platform image processing application built with Flutter and OpenCV. The app provides real-time image processing capabilities with an intuitive before/after comparison interface.

## Project Structure

javascript

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`  everpixel/  ├── lib/  │   ├── controllers/  │   │   └── image_controller.dart    # Image processing logic controller  │   ├── providers/  │   │   └── image_provider.dart      # State management  │   ├── screens/  │   │   └── home_screen.dart         # Main UI screen  │   ├── services/  │   │   └── image_service.dart       # Native code bridge  │   └── main.dart                    # Entry point  ├── open_cv/  │   └── my_functions.cpp             # Native OpenCV implementations  ├── linux/                           # Linux platform code  └── macos/                          # macOS platform code  `

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

1.  **Clone Repository**

bash

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`  git clone https://github.com/yourusername/everpixel.git  cd everpixel  `

1.  **Flutter Setup**

bash

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`  flutter pub get  `

1.  **OpenCV Setup**

For Linux:bash

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`  sudo apt-get update  sudo apt-get install libopencv-dev  cd open_cv  cmake .  make  `

For macOS:bash

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`  brew install opencv  cd open_cv  cmake .  make  `

1.  **Run the App**

bash

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`  flutter run  `

## Development Guide

### Code Organization

- controllers/: Business logic and state management
- providers/: App-wide state management using Provider
- screens/: UI components and screens
- services/: Platform integration and native code bridges
- open_cv/: Native OpenCV implementations

### Key Components

#### Flutter

- ImageController: Manages image processing operations
- ImageProvider: Handles app state and image data
- ImageService: FFI bridge to native code
- HomeScreen: Main UI implementation

#### Native (C++)

- my_functions.cpp: OpenCV implementations for:

  - Grayscale conversion
  - Blur effects
  - Edge detection
  - Image sharpening

### Best Practices

1.  **Code Style**

    - Follow Flutter/Dart style guidelines
    - Use meaningful names
    - Add documentation for complex logic

2.  **Error Handling**

    - Implement proper error handling
    - Add user feedback
    - Log errors appropriately

3.  **Performance**

    - Optimize image processing
    - Handle large images efficiently
    - Implement loading states

## Usage

1.  Launch the app
2.  Select an image from gallery
3.  Choose a processing effect
4.  Use comparison slider
5.  Apply or cancel changes

## Contributing

1.  Fork the repository
2.  Create feature branch
3.  Commit changes
4.  Push to branch
5.  Create Pull Request

## License

MIT License - see LICENSE file

## Contact

For issues and feature requests, please use the GitHub issue tracker.
