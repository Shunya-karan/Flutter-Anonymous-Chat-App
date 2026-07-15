import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/home/homeScreen.dart';
import 'package:frontend/services/userServices.dart';
import 'package:frontend/widgets/CustomWidgets/customButton.dart';
import 'package:frontend/widgets/HomeScreenWidgets/securityFooter.dart';
import 'package:frontend/widgets/Profile/profileForm.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {

  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final bioController = TextEditingController();
  final userNameController = TextEditingController();
  String? selectedGender;
  List <String> selectedInterests=[];
  File? profileImage;
  bool isLoading =false;

  Future<void> EditProfile() async{
    if (selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select your gender"),
        ),
      );
      return;
    }
    if (selectedInterests.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select at least one interest"),
        ),
      );
      return;
    }
    try{
      setState(() {
        isLoading =true;
      });
      await UserService.updateProfile(
          username: userNameController.text.trim(),
          gender:selectedGender! ,
          bio: bioController.text.trim(),
          interests: selectedInterests,
          profileImage: profileImage
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Profile Updated")));
      Navigator.pop(context);

    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.response?.data["message"]
              ?? e.message ?? "Something went wrong")
          ));}
    finally{
      if(mounted){
        setState(() {
          isLoading=false;
        });
      }
    }
  }

  @override
  void dispose() {
    userNameController.dispose();
    bioController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Update Your Profile",
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium,
            ),
            const SizedBox(height: 8),

            Text(
              " Personalize your account.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 30,),

            ProfileForm(profileImage: profileImage,
                onImageSelected: (image) {
                  setState(() {
                    profileImage = image;
                  });
                },
                showUsername: true,
                bioController: bioController,
                selectedGender: selectedGender,
                onGenderChanged: (gender){
                  setState(() {
                    selectedGender=gender;
                  });
                },
                selectedInterests: selectedInterests,
                onInterestsChanged: (interest){
                  setState(() {
                    selectedInterests=interest;
                  });
                }
            ),

            const SizedBox(height: 15),
            //Continue Button
            const SizedBox(height: 30),
            CustomButton(
              text: isLoading?"Uploading profile..":"Finish Setup",
              isLoading: isLoading,
              onPressed: isLoading ? null : EditProfile,
            ),
          ],
        ),
      )),
      bottomNavigationBar: SafeArea(child: Securityfooter()),

    );
  }
}
