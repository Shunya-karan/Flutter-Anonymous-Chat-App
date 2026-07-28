import 'package:flutter/material.dart';
import 'package:frontend/providers/userprovider.dart';
import 'package:frontend/screens/profile/edit_profile.dart';
import 'package:frontend/widgets/CustomWidgets/customButton.dart';
import 'package:frontend/widgets/HomeScreenWidgets/securityFooter.dart';
import 'package:frontend/widgets/ProfileWidgets/profileHeader.dart';
import 'package:frontend/widgets/ProfileWidgets/profile_details_card.dart';
import 'package:provider/provider.dart';


class profileScreen extends StatefulWidget {
  const profileScreen({super.key});

  @override
  State<profileScreen> createState() => _profileScreenState();
}

class _profileScreenState extends State<profileScreen> {
  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>().user;

    return RefreshIndicator(
      onRefresh: ()async{
        await context.read<UserProvider>().refreshUser();
      },
      child: Scaffold(
        appBar: AppBar(),
        body:  SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                ProfileHeader(username: user!.username,
                bio: user.bio,
                profileImage: user.profileImage,
                ),
                SizedBox(height: 24,),
                ProfileDetails(gender: user.gender!, interest: user.interests),
                SizedBox(height: 60,),
                CustomButton(icon: Icons.edit, text: "Edit profile",
                    onPressed: ()async{
                  await Navigator.push(context, MaterialPageRoute(builder: (_)=>EditProfileScreen()));
                    }),
                SizedBox(height: 20,),
                CustomButton(icon: Icons.remove_circle,
                    text: "Delete profile",
                    colors: Colors.red,
                    onPressed: ()async{
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                           backgroundColor: Theme.of(context).colorScheme.error,
                          content: Text("This Feature Coming Soon"))
                  );
                    }),
              ],
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(child: Securityfooter()),
      ),
    );

  }
}
