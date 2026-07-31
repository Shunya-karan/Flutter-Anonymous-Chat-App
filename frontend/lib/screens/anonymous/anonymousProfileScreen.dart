import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/anonymous/anonymousWidgets/avatarGrid.dart';
import 'package:frontend/screens/anonymous/anonymousWidgets/displayNameCard.dart';
import 'package:frontend/screens/anonymous/anonymousWidgets/saveButton.dart';
import 'package:frontend/screens/home/homeScreen.dart';
import 'package:frontend/services/anonymousService.dart';
import 'package:frontend/theme/appColor.dart';
import 'package:frontend/widgets/CustomWidgets/CustomeMessanger.dart';
import 'package:frontend/widgets/HomeScreenWidgets/securityFooter.dart';

class AnonymousProfileScreen extends StatefulWidget {
  final bool isEdit;
   AnonymousProfileScreen({super.key,
  this.isEdit=false
  });

  @override
  State<AnonymousProfileScreen> createState() =>
      _AnonymousProfileScreenState();
}

class _AnonymousProfileScreenState extends State<AnonymousProfileScreen> {
  String displayName = "";
  String? selectedAvatar;
  bool isSaving = false;

  // saveProfile
  Future<void>saveProfile()async{
    if (isSaving) return;
    if(selectedAvatar==null||displayName.trim().isEmpty){
      CustomMessenger.show(context, message:"Please Select Avatar or Generate Name");
      return;
    }
    setState(() {
      isSaving=true;
    });
    try{
      if(widget.isEdit){
        await AnonymousService.updateAnonymousProfile(
            displayName: displayName,
            avatar: selectedAvatar!);
      }else{
        await AnonymousService.createAnonymousProfile(
            displayName: displayName,
            avatar: selectedAvatar!);
      }

      if(!mounted) return;
      CustomMessenger.show(context,
          message:widget.isEdit?"Profile Updated Successfully":"Profile Created Successfully",
          bgColor: Theme.of(context).colorScheme.secondary
      );
      if(widget.isEdit){
        Navigator.pop(context);
      }else{
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const HomePage(),
          ),
              (route) => false,
        );
      }

    }on DioException catch(e){
      final message =e.response?.data["message"]??"Something Went Wrong";
      if(!mounted) return;
      CustomMessenger.show(context, message: message);
    }finally{
      if(mounted){
        setState(() {
          isSaving=false;
        });
      }
    }
  }
  // loadAnonymousProfile

  Future<void>loadAnonymousProfile()async{
    try{
      final profile=await AnonymousService.getAnonymousProfile();
      setState(() {
        displayName=profile.displayName;
        selectedAvatar=profile.avatar;
      });
    }on DioException catch(e) {
      if(e.response?.statusCode==404){
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_)=>AnonymousProfileScreen(isEdit: false)));
      }
      final message = e.response?.data["message"] ?? "Something Went Wrong";
      if (!mounted) return;
      CustomMessenger.show(context, message: message);
    }catch(e){
      CustomMessenger.show(context, message: e.toString());
    }
  }

  Future<void> generateName()async {
    try {
      final response = await AnonymousService.generateAnonymousName();
      setState(() {
        displayName = response.data["displayName"];
      });
    } on DioException catch (e) {
      final message = e.response?.data["message"] ??
          "Something went wrong";
      CustomMessenger.show(context, message: message,
          bgColor: AppColors.error);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  void initState(){
    super.initState();
    if(widget.isEdit){
      loadAnonymousProfile();
    }else{
      generateName();
    }
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    final horizontalPadding = size.width * 0.05;
    final avatarSize = size.width * 0.28 > 120
        ? 120.0
        : size.width * 0.28;

    return Scaffold(
      appBar: widget.isEdit?AppBar(

      ):null,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 20,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 550),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Welcome Text
                  Text(
                    widget.isEdit
                        ?"Update Your Identity"
                        :"Create Your Identity",
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Choose an avatar and generate an anonymous name to represent you while chatting. Your real identity always stays private.",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: size.height * 0.04),
                  // Selected Avatar

                  Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: avatarSize,
                      height: avatarSize,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.colorScheme.primaryContainer,
                        border: Border.all(
                          color: theme.colorScheme.primary,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.18),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: selectedAvatar == null
                          ? Icon(
                        Icons.person_rounded,
                        size: avatarSize * 0.55,
                        color: theme.colorScheme.secondary,
                      )
                          : Padding(
                        padding: const EdgeInsets.all(8),
                        child: Image.asset(
                          "assets/avatar/$selectedAvatar.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: size.height * 0.04),
                  // Avatar selecting
                  Card(
                    elevation: 2,
                    shadowColor: Colors.black.withOpacity(0.08),
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

                  const SizedBox(height: 18),
                  // NAme generator
                  Card(
                    elevation: 2,
                    shadowColor: Colors.black.withOpacity(0.08),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: DisplayNameCard(
                        displayName: displayName,
                        onGenerateName: generateName,
                      ),
                    ),
                  ),

                  SizedBox(height: size.height * 0.04),
                  // Save Button
                  SaveButton(
                    onPressed: saveProfile,
                    isLoading: isSaving,
                    buttonText: widget.isEdit
                    ?"Save Changes "
                    :"Save Profile",
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(child: Securityfooter()),
    );
  }
}