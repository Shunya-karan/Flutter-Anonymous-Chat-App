import 'package:flutter/material.dart';
import 'package:frontend/screens/anonymous/anonymousProfileScreen.dart';
import 'package:frontend/screens/profile/profileScreen.dart';
import 'package:frontend/screens/settings/aboutTalkLoopScreen.dart';
import 'package:frontend/screens/settings/rate_talkloop_screen.dart';
import 'package:frontend/widgets/CustomWidgets/CustomeMessanger.dart';
import 'package:frontend/widgets/Dialogs/appearanceDialog.dart';
import 'package:frontend/widgets/logoutButton.dart';
import 'package:frontend/widgets/Menus/profileHeader.dart';
import 'package:frontend/widgets/Menus/settingTile.dart';

class AppDrawer extends StatelessWidget {
  final String username;
  final String? bio;
  final String? profileImage;

  const AppDrawer({
    super.key,
    required this.username,
    this.bio,
    this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      backgroundColor: colorScheme.surface,
      elevation: 8,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          bottomLeft: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // profile header
            ProfileHeader(
              username: username,
              bio: bio,
              profileImage: profileImage,
            ),
            const SizedBox(height: 30),
            // Setting Text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "SETTINGS",
                  style: TextStyle(
                    fontSize: 12,
                    letterSpacing: 1.3,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // All Functions
            Expanded(
              child: ListView(
                padding:
                const EdgeInsets.symmetric(horizontal: 8),
                children: [
                  // Profile
                  SettingsTile(
                    icon: Icons.person_outline,
                    title: "Profile",
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>
                        profileScreen()
                      ));
                    },
                  ),
                  // Anonymous Profile
                  SettingsTile(
                    icon: Icons.person_pin_outlined,
                    title: "Anonymous Profile",
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>
                          AnonymousProfileScreen(isEdit: true,)
                      ));
                    },
                  ),
                  // Appearance
                  SettingsTile(
                    icon: Icons.palette_outlined,
                    title: "Appearance",
                    onTap: () {
                      Navigator.pop(context);
                      showDialog(context: context, builder: (_)=>AppearanceDialog()
                      );
                    },
                  ),
                  // Privacy Policy
                  SettingsTile(
                    icon: Icons.privacy_tip_outlined,
                    title: "Privacy Policy",
                    onTap: () {
                      CustomMessenger.show(context, message: "UNDER PROCESSING");
                    },
                  ),
                  //About
                  SettingsTile(
                    icon: Icons.info_outline,
                    title: "About TalkLoop",
                    onTap: () {
                      Navigator.push(context,
                      MaterialPageRoute(builder: (_)=>AboutTalkLoopScreen())
                      );
                    },
                  ),
                  // Taring
                  SettingsTile(
                    icon: Icons.star_outline,
                    title: "Rate TalkLoop",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RateTalkLoopScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            //Logout Button
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 18),
              child: LogoutButton(),
            ),

            const SizedBox(height: 25),

            Text(
              "TalkLoop v1.0.0",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}