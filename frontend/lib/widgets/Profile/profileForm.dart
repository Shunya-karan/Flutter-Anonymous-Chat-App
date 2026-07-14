import 'package:flutter/material.dart';
import 'package:frontend/widgets/CustomWidgets/customTextfield.dart';
import 'package:frontend/widgets/Profile/InterestSelecter.dart';
import 'package:frontend/widgets/Profile/genderselecter.dart';
import 'dart:io';

import 'package:frontend/widgets/Profile/profile_image_picker.dart';

class ProfileForm extends StatelessWidget {
  final File? profileImage;
  final ValueChanged<File?> onImageSelected;
  final bool showUsername;

  final TextEditingController?usernameController;
  final TextEditingController bioController;

  final String? selectedGender;
  final ValueChanged<String> onGenderChanged;

  final List<String> selectedInterests;
  final ValueChanged<List<String>> onInterestsChanged;

  const ProfileForm({
    super.key,
    required this.profileImage,
    required this.onImageSelected,
    required this.showUsername,
    this.usernameController,
    required this.bioController,
    required this.selectedGender,
    required this.onGenderChanged,
    required this.selectedInterests,
    required this.onInterestsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        //profileImage
        Center(
          child: ProfileImagePicker(
            image: profileImage,
            onImageSelected:onImageSelected
          ),
        ),

        const SizedBox(height: 35),
        if (showUsername) ...[
          CustomTextField(
            prefixIcon: Icons.person,
            controller: usernameController!,
            hintText: "Username",
            labelText: "Username",
          ),
          const SizedBox(height: 20),
        ],

        //bio
        CustomTextField(

          controller: bioController,
          labelText: "Tell us about yourself",
          hintText: "Tell  Something About Yourself..",
          maxLines: 4,
          prefixIcon: Icons.edit,
        ),
        const SizedBox(height: 20),

        //gender
        Text(
          "Gender",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        GenderSelector(selectedGender: selectedGender,
            onChanged: onGenderChanged),
        const SizedBox(height: 20),

        //interest
        Text(
          "Select Interests",
          style: Theme.of(context).textTheme.titleMedium,),
        InterestSelector(
          selectedInterests: selectedInterests,
          onChanged: onInterestsChanged,
        ),
      ],
    );
  }
}