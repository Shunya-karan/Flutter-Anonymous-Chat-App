import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/home/homeScreen.dart';
import 'package:frontend/services/userServices.dart';
import 'package:frontend/widgets/CustomWidgets/customButton.dart';
import 'package:frontend/widgets/HomeScreenWidgets/securityFooter.dart';
import 'package:frontend/widgets/Profile/InterestSelecter.dart';
import 'package:frontend/widgets/Profile/genderselecter.dart';
import 'package:frontend/widgets/Profile/profile_image_picker.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:frontend/widgets/CustomWidgets/customTextfield.dart';

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
  final ImagePicker picker =ImagePicker();
  bool isLoading =false;

  Future<void> continueProfile() async{

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
      final response= await UserService.updateProfile(
          gender:selectedGender! ,
          bio: bioController.text.trim(),
          interests: selectedInterests,
          profileImage: profileImage
      );

      Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (Context)=>HomePage())
      );
    } on DioException catch (e) {

  ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
  content: Text(
  e.response?.data["message"] ?? e.message ?? "Something went wrong",
  ),
  ),
  );
  }{
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
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Complete Your Profile",
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
              //Profile Image
              ProfileImagePicker(
                image: profileImage,
                onImageSelected: (image) {

                  setState(() {
                    profileImage = image;
                  });
                },
              ),
              const SizedBox(height: 35),
              //Gender
              Text(
                "Gender",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 15),
              GenderSelecter(selectedGender: selectedGender,
                  onChanged: (gender){
                setState(() {
                  selectedGender=gender;
                });
              }),
              //Bio
              SizedBox(height: 20),
              CustomTextField(
                controller: bioController,
                labelText: "Tell us about yourself",
                hintText: "Tell  Something About Yourself..",
                maxLines: 4,
                prefixIcon: Icons.notes_outlined,
              ),
              //Interest
               SizedBox(height: 20),
              Text(
                "Select Interests",
                style: Theme.of(context).textTheme.titleMedium,),
              InterestSelector(selectedInterests: selectedInterests,
                  onChanged: (interest){
                    setState(() {
                      selectedInterests=interest;
                    });
                  }),
              const SizedBox(height: 15),

              //Continue Button
              const SizedBox(height: 30),
              CustomButton(
                text: isLoading?"Uploading profile..":"Continue",
                isLoading: isLoading,
                  onPressed: isLoading ? null : continueProfile,
              ),

            ],
          ),
        ),
      )),
      bottomNavigationBar: SafeArea(child: Securityfooter()),

    );
  }
}
