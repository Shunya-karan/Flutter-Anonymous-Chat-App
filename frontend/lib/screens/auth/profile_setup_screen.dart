import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/providers/userprovider.dart';
import 'package:frontend/screens/anonymous/anonymousProfileScreen.dart';
import 'package:frontend/screens/home/homeScreen.dart';
import 'package:frontend/services/userServices.dart';
import 'package:frontend/widgets/CustomWidgets/CustomeMessanger.dart';
import 'package:frontend/widgets/CustomWidgets/customButton.dart';
import 'package:frontend/widgets/HomeScreenWidgets/securityFooter.dart';
import 'package:frontend/widgets/ProfileWidgets/profileForm.dart';
import 'dart:io';

import 'package:provider/provider.dart';
//after registartion this screen will open for completing the profile
class ProfileSetupScreen extends StatefulWidget {

  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final bioController = TextEditingController();
  String? selectedGender;
  List <String> selectedInterests=[];
  File? profileImage;
  bool isLoading =false;

  Future<void> continueProfile() async{
    if (selectedGender == null) {
      CustomMessenger.show(context, message: "Please select your gender");
      return;
    }
    if (selectedInterests.isEmpty) {
      CustomMessenger.show(context, message: "Please select at least one interest");
      return;
    }
    try{
      setState(() {
        isLoading =true;
      });
      await UserService.updateProfile(
          gender:selectedGender! ,
          bio: bioController.text.trim(),
          interests: selectedInterests,
          profileImage: profileImage
      );
      await context.read<UserProvider>().loadUser();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const AnonymousProfileScreen(),
        ),
            (route) => false,
      );

    } on DioException catch (e) {
      CustomMessenger.show(context, message: e.response?.data["message"]
          ?? e.message.toString() ?? "Something went wrong");
    }
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
              "Complete Your ProfileWidgets",
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              "Almost done! Personalize your account.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 30,),

            ProfileForm(profileImage: profileImage,
                imageUrl: null,
                onImageSelected: (image) {
                      setState(() {
                        profileImage = image;
                      });
                    },
                showUsername: false,
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
                onPressed: isLoading ? null : continueProfile,
            ),
          ],
        ),
      )),
      bottomNavigationBar: SafeArea(child: Securityfooter()),

    );
  }
}
