import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/anonymous/anonymousWidgets/avatarGrid.dart';
import 'package:frontend/screens/anonymous/anonymousWidgets/displayNameCard.dart';
import 'package:frontend/services/anonymousService.dart';
import 'package:frontend/theme/appColor.dart';

class AnonymousProfileScreen extends StatefulWidget {
  const AnonymousProfileScreen({super.key});

  @override
  State<AnonymousProfileScreen> createState() =>
      _AnonymousProfileScreenState();
}

class _AnonymousProfileScreenState extends State<AnonymousProfileScreen> {
  String? selectedAvatar;
  String displayName = "";
  bool isGenerating = false;


  Future<void> generateName()async{
    try{
      setState(() {
        isGenerating=true;
      });
      final response = await AnonymousService.generateAnonymousName();
      setState(() {
        displayName=response.data["displayName"];
      });
    }on DioException catch (e) {
      final message = e.response?.data["message"] ??
          "Something went wrong";
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      );
    }catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: const Text("${e}"),
      //   backgroundColor: Colors.red,
      //   behavior: SnackBarBehavior.floating,
      //   duration: const Duration(seconds: 3),
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(12),
      //   ),
      // ),
      // );
      print(e);
    }finally{
      if(mounted){
        setState(() {
          isGenerating=false;
        });
      }
    }
  }

  @override
  void initState(){
    super.initState();
    generateName();
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Anonymous Profile"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Create Your Identity",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              Text(
                "Choose an avatar and Generate anonymous name "
                    "to represent you while chatting. Your real identity stays private.",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 30),

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

              DisplayNameCard(displayName: displayName,
                  onGenerate: generateName),

              const SizedBox(height: 30),

              SizedBox(
                height: 54,
                child: FilledButton(
                  onPressed: selectedAvatar == null ? null : () {},
                  child: const Text("Continue"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}