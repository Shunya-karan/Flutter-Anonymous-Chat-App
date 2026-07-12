import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileImagePicker extends StatefulWidget {
  final File? image;
  final ValueChanged<File?> onImageSelected;

  const ProfileImagePicker({
    super.key,
    required this.image,
    required this.onImageSelected,
  });

  @override
  State<ProfileImagePicker> createState() =>
      _ProfileImagePickerState();
}

class _ProfileImagePickerState
    extends State<ProfileImagePicker> {

  final ImagePicker picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxWidth: 800,
      maxHeight: 800,
    );

    if (pickedImage == null) return;


    widget.onImageSelected(
      File(pickedImage.path),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.grey.shade200,
          backgroundImage: widget.image != null
              ? FileImage(widget.image!)
              : null,
          child: widget.image == null
              ? const Icon(
            Icons.person,
            size: 60,
          )
              : null,
        ),

        Positioned(
          bottom: 0,
          right: 0,
          child: CircleAvatar(
            radius: 18,
            child: IconButton(
              onPressed: pickImage,
              icon: const Icon(
                Icons.camera_alt,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}