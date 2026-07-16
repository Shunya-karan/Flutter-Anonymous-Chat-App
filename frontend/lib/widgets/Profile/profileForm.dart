import 'package:flutter/material.dart';
import 'package:frontend/widgets/CustomWidgets/customTextfield.dart';
import 'package:frontend/widgets/Profile/InterestSelecter.dart';
import 'package:frontend/widgets/Profile/genderselecter.dart';
import 'dart:io';

import 'package:frontend/widgets/Profile/profile_image_picker.dart';

class ProfileForm extends StatelessWidget {
  final File? profileImage;
  final String? imageUrl;
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
    this.imageUrl,
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
    final colorScheme = Theme.of(context).colorScheme;

    Widget sectionCard({
      required Widget child,
    }) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: colorScheme.outline.withOpacity(0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      );
    }

    Widget sectionTitle(IconData icon, String title) {
      return Row(
        children: [
          Icon(icon, color: colorScheme.primary,size: 22),
          const SizedBox(width: 8),
          Text(title, style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Profile Image
          Center(
            child: Column(
              children: [
                ProfileImagePicker(image: profileImage,
                  imageUrl: imageUrl,
                  onImageSelected: onImageSelected,
                ),
                const SizedBox(height: 10),
                Text("Upload Profile Picture",
                  style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),

          const SizedBox(height: 30),

          /// Username
          if (showUsername) ...[
            sectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sectionTitle(Icons.person_outline, "Username"),
                  const SizedBox(height: 16),
                  CustomTextField(
                    prefixIcon: Icons.person,
                    controller: usernameController!,
                    hintText: "Username",
                    labelText: "Username",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
          ],

          /// Bio
          sectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sectionTitle(Icons.edit_note, "About You"),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: bioController,
                  labelText: "Tell us about yourself",
                  hintText: "Tell something about yourself...",
                  maxLines: 4,
                  prefixIcon: Icons.edit,
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          /// Gender
          sectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sectionTitle(Icons.wc, "Gender"),
                const SizedBox(height: 16),
                GenderSelector(
                  selectedGender: selectedGender,
                  onChanged: onGenderChanged,
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          /// Interests
          sectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sectionTitle(Icons.favorite_outline, "Select Interests"),
                const SizedBox(height: 16),
                InterestSelector(
                  selectedInterests: selectedInterests,
                  onChanged: onInterestsChanged,
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }}