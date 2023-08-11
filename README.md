# Awesome Image Selector

The `AwesomeImageSelector` is a Flutter widget that allows you to display and select images with ease. It provides a customizable interface for selecting images and triggers a callback when the image is changed or added. This widget is perfect for scenarios where you need to offer users the ability to choose or update images within your app.

## Features

- Display an image within a customizable card layout.
- Provide callbacks for handling image changes.
- Customize the appearance of the card, including outer margins and background color.
- Supports displaying an initial image, which can be updated through user interaction.
- Built-in support for specifying custom text for selecting and changing images.

## Getting Started

To use the `AwesomeImageSelector` widget in your Flutter project, follow these steps:

1. Add the package to your `pubspec.yaml` file:

```yaml
dependencies:
  awesome_image_selector: ^<latest_version>
```

2. Import the package in your Dart code:

```dart
import 'package:awesome_image_selector/awesome_image_selector.dart';
```

3. Add the `AwesomeImageSelector` widget to your widget tree:

```dart
AwesomeImageSelector(
  onImageChanged: (XFile file) {
    // Handle the changed image file here
  },
  // can be any image, network mostly
  initialImage: AssetImage('assets/placeholder_image.png'),
  cardOuterMargin: EdgeInsets.all(16.0), // optional
  bgCardColor: Colors.grey[200],
  selectText: 'Select Image',
  changeText: 'Change Image',
)
```

## Example

For a more comprehensive example, you can check the `/example` folder in the package repository.

## Additional Information

- For more details and usage examples, visit the official documentation at [https://salehwaleed.com](https://salehwaleed.com).
- If you encounter any issues, have questions, or want to contribute to the package, please visit the [GitHub repository](https://github.com/alex-web0/awesome_image_selector).
- This package is licensed under the MIT License.

---

Made with ❤️ by [Salih](https://salehwaleed.com)
```

