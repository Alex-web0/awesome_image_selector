import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';

/// This does everything for you, and provides a simple callback to retrieve the image, and do
/// whatever you want with it!
class AwesomeImageSelector extends StatefulWidget {
  const AwesomeImageSelector({
    super.key,
    required this.onImageChanged,
    this.cardOuterMargin,
    this.initialImage,
    this.bgCardColor,
    this.selectText,
    this.changeText,
  });

  final Function(XFile file) onImageChanged;
  final EdgeInsetsGeometry? cardOuterMargin;

  /// The initial image only, it will update once changed automatically
  final ImageProvider? initialImage;
  final Color? bgCardColor;

  final String? selectText;
  final String? changeText;

  @override
  State<AwesomeImageSelector> createState() => _AwesomeImageSelectorState();
}

class _AwesomeImageSelectorState extends State<AwesomeImageSelector> {
  XFile? imageFile;

  @override
  Widget build(BuildContext context) {
    Widget selectorOrEditor = widget.initialImage == null
        ? buildImageSelector(context)
        : buildImageSelectorWithImageSelected(context, widget.initialImage!);

    return imageFile == null

        /// if there is NO file loaded, load either the latest version from editing, OR just build a new plain
        ? selectorOrEditor

        /// Opens Image, loads and shows it, adds also an edit button!
        : FutureBuilder<Uint8List>(
            future: imageFile!.readAsBytes(),
            builder: (context, snapshot) {
              const loader = Center(child: CircularProgressIndicator());
              if (snapshot.hasError) return loader;
              if (snapshot.connectionState == ConnectionState.waiting) {
                return loader;
              }
              if (snapshot.data == null) {
                return const Text("Error Loading images >~<");
              }

              return buildImageSelectorWithImageSelected(
                  context, MemoryImage(snapshot.data!));
            });
  }

  /// Builds the default selector card
  Widget buildImageSelector(context) {
    return Card(
      margin: widget.cardOuterMargin ?? EdgeInsets.zero,
      color: widget.bgCardColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: selectAndUpdateImage,
                  icon: Icon(
                    Icons.add,
                    size: 48,
                    color: Theme.of(context).primaryColor,
                  )),
              Text(widget.selectText ?? "UPLOAD IMAGE"),
              const SizedBox(height: 16),
            ],
          )
        ],
      ),
    );
  }

  /// Builds an image, with a button on top of it that uses the same [selectAndUpdateImage] function
  /// to edit the image, change the state and re-call [widget.onImageChanged]
  Widget buildImageSelectorWithImageSelected(context, ImageProvider image) {
    return Stack(
      children: [
        Card(
            child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(image: image, fit: BoxFit.cover)),
          constraints: const BoxConstraints(minHeight: 100, maxHeight: 256),
        )),
        Positioned(
            left: 16.0,
            bottom: 16.0,
            child: Opacity(
              opacity: 0.80,
              child: FilledButton.icon(
                  onPressed: selectAndUpdateImage,
                  icon: const Icon(Icons.edit),
                  label: Text(widget.changeText ?? "EDIT IMAGE")),
            ))
      ],
    );
  }

  /// Picks an image, changes the state of the widget if a valid image is selected!
  selectAndUpdateImage() async {
    XFile? imageOrNot;

    try {
      if (Platform.isAndroid || Platform.isIOS) {
        final picker = ImagePicker();
        imageOrNot = await picker.pickImage(source: ImageSource.gallery);
      }
      throw Exception();
    } catch (e) {
      Uint8List? imgBytes = await ImagePickerWeb.getImageAsBytes();
      imageOrNot = imgBytes == null ? null : XFile.fromData(imgBytes);
    }

    if (imageOrNot == null) return;

    setState(() {
      imageFile = imageOrNot;
    });

    widget.onImageChanged(imageOrNot);
  }
}
