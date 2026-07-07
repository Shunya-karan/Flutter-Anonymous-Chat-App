import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/home/homeScreen.dart';
import 'package:frontend/services/userServices.dart';
import 'package:frontend/widgets/customButton.dart';
import 'dart:io';

import 'package:frontend/widgets/customTextfield.dart';

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
  List<String> interests = [
    "Sports",
    "Gaming",
    "Music",
    "Coding",
    "Movies",
    "Books",
    "Travel",
    "Food",
    "Photography",
    "Fitness",
    "Technology",
    "Art",
  ];

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
          interests: selectedInterests);
      Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (Context)=>HomePage())
      );
    }on DioException catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.response?.data["message"] ??
                "Something went wrong",),),
      );
    }finally{
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
              Stack(
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundImage:
                        profileImage!=null?FileImage(profileImage!):null,
                    child: profileImage==null
                        ?const Icon(Icons.person ,size: 50,)
                        :null,
                  ),
                  Positioned(
                      bottom: 0,right: 0,
                      child: CircleAvatar(
                    radius: 18,
                    child: IconButton(onPressed: (){},
                        icon: Icon(Icons.camera_alt,size: 20,)),
                  ))
                ],
              ),
              const SizedBox(height: 35),
              //Gender
              Text(
                "Gender",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 15),
              Wrap(
                spacing: 10,
                children: ["Male", "Female", "Other"].map((gender) {
                  return ChoiceChip(
                    label: Text(gender),
                    selected: selectedGender == gender,
                    onSelected: (selected) {
                      setState(() {
                        selectedGender = gender;
                      });
                    },
                  );
                }).toList(),
              ),
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
              const SizedBox(height: 15),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: interests.map((interest) {
                  final selected = selectedInterests.contains(interest);
                  return FilterChip(
                    label: Text(interest),
                    selected: selected,
                    onSelected: (value) {
                      setState(() {
                        if (selected) {
                          selectedInterests.remove(
                              interest);
                        } else {
                          selectedInterests.add(
                              interest);
                        }
                      });
                    },
                  );

                }).toList(),
              ),

              //Continue Button
              const SizedBox(height: 30),
              CustomButton(
                text: "Continue",
                isLoading: isLoading,
                onPressed: continueProfile,
              ),

            ],
          ),
        ),
      )),
    );
  }
}
