import 'package:flutter/material.dart';
import 'package:frontend/widgets/logout_button.dart';
import 'package:frontend/widgets/profile_header.dart';
import 'package:frontend/widgets/setting_tile.dart';

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

            ProfileHeader(
              username: username,
              bio: bio,
              profileImage: profileImage,
            ),

            const SizedBox(height: 30),

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

            Expanded(
              child: ListView(
                padding:
                const EdgeInsets.symmetric(horizontal: 8),
                children: [
                  SettingsTile(
                    icon: Icons.person_outline,
                    title: "Edit Profile",
                    onTap: () {},
                  ),

                  SettingsTile(
                    icon: Icons.dark_mode_outlined,
                    title: "Appearance",
                    onTap: () {},
                  ),

                  SettingsTile(
                    icon: Icons.privacy_tip_outlined,
                    title: "Privacy Policy",
                    onTap: () {},
                  ),

                  SettingsTile(
                    icon: Icons.info_outline,
                    title: "About TalkLoop",
                    onTap: () {},
                  ),
                ],
              ),
            ),

            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 18),
              child: LogoutButton(
                onPressed: () {},
              ),
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