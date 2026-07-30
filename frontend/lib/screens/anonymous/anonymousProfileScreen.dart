import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/anonymous/anonymousWidgets/avatarGrid.dart';
import 'package:frontend/screens/anonymous/anonymousWidgets/displayNameCard.dart';
import 'package:frontend/screens/anonymous/anonymousWidgets/saveButton.dart';
import 'package:frontend/screens/home/homeScreen.dart';
import 'package:frontend/services/anonymousService.dart';
import 'package:frontend/theme/appColor.dart';

class AnonymousProfileScreen extends StatefulWidget {
  const AnonymousProfileScreen({super.key});

  @override
  State<AnonymousProfileScreen> createState() =>
      _AnonymousProfileScreenState();
}

class _AnonymousProfileScreenState extends State<AnonymousProfileScreen> {
  String displayName = "";
  String? selectedAvatar;
  bool isSaving = false;


  Future<void>saveProfile()async{
    if(selectedAvatar==null||displayName==""){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please Select Avatar or Generate Name"))
      );
      return;
    }
    try{
      setState(() {
        isSaving=true;
      });
      await AnonymousService.createAnonymousProfile(
          displayName: displayName,
          avatar: selectedAvatar!);
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
        "Profile Created Successfully"
      )));
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const HomePage(),
        ),
            (route) => false,
      );
    }on DioException catch(e){
      final message =e.response?.data["message"]??"Something Went Wrong";
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message,)
      ));
    }finally{
      if(mounted){
        setState(() {
          isSaving=false;
        });
      }
    }
  }
  @override
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome Text
              Text(
                "Create Your Identity",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // About anonymousScreen Text
              Text(
                "Choose an avatar and Generate anonymous name "
                    "to represent you while chatting. Your real identity stays private.",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 30),

              // Selected Avatar
              Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.primaryContainer,
                    border: Border.all(
                      color: theme.colorScheme.shadow,
                      width: 3,
                    ),
                  ),
                  child: selectedAvatar == null
                      ? Icon(
                    Icons.person,
                    size: 60,
                    color: theme.colorScheme.secondary,
                  )
                      : Padding(
                    padding: const EdgeInsets.all(12),
                    child: Image.asset(
                      "assets/avatar/$selectedAvatar.png",
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Select Avatar Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: AvatarGrid(
                    selectedAvatar: selectedAvatar,
                    onAvatarSelected: (avatar) {
                      setState(() {
                        selectedAvatar = avatar;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // DisplayNAme CArd
              DisplayNameCard(displayName: displayName,
              onGenerateName: (name){
                setState(() {
                  displayName=name;
                });
              },
              ),

              const SizedBox(height: 30),

              SaveButton(onPressed: saveProfile, isLoading: isSaving)
            ],
          ),
        ),
      ),
    );
  }
}