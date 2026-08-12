import 'package:flutter/material.dart';
import 'package:frontend/theme/appColor.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color background = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final Color surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final Color textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final Color subtitleColor = isDark ? AppColors.darkSubtitle : AppColors.lightSubtitle;
    final Color borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: surface,
        elevation: 0,
        title: Text(
          "Privacy Policy",
          style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
        ),
        iconTheme: IconThemeData(color: textColor),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: Image.asset(
                'assets/images/LOGO.png',
                height: 64,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Last updated: August 12, 2026",
              textAlign: TextAlign.center,
              style: TextStyle(color: subtitleColor, fontSize: 13),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _section(
                    context,
                    "1. Introduction",
                    "TalkLoop is an anonymous chat application that allows users "
                        "to meet and communicate with other users. This Privacy "
                        "Policy explains what information TalkLoop collects, how "
                        "it is used, and how it is handled.",
                    textColor,
                    subtitleColor,
                  ),
                  _section(
                    context,
                    "2. Information We Collect",
                    "When you create an account, TalkLoop may collect:",
                    textColor,
                    subtitleColor,
                    bullets: const [
                      "Username",
                      "Email address",
                      "Password/credential information",
                      "Interests",
                      "Profile image",
                      "Bio",
                      "Gender preference",
                    ],
                    footer: "TalkLoop also creates an anonymous profile containing:",
                    footerBullets: const [
                      "Anonymous display name",
                      "Anonymous avatar",
                    ],
                    trailingText:
                    "Your anonymous profile is used when matching and chatting with other users.",
                  ),
                  _section(
                    context,
                    "3. Anonymous Chat",
                    "TalkLoop is designed to allow users to interact without "
                        "revealing their account identity to strangers. During a "
                        "chat, your anonymous display name and anonymous avatar "
                        "may be shown to the person you are matched with. Your "
                        "account information, such as your email address, is not "
                        "intended to be displayed to your chat partner.",
                    textColor,
                    subtitleColor,
                  ),
                  _section(
                    context,
                    "4. Block and Report",
                    "TalkLoop allows users to block and report other users. "
                        "When you block someone, TalkLoop records the "
                        "relationship between your account and the blocked "
                        "account so that the users can be prevented from being "
                        "matched again.\n\nWhen you report someone, TalkLoop records:",
                    textColor,
                    subtitleColor,
                    bullets: const [
                      "The reporting user",
                      "The reported user",
                      "The reason for the report",
                      "The time of the report",
                    ],
                    trailingText:
                    "This information may be used to enforce safety measures and prevent unwanted interactions.",
                  ),
                  _section(
                    context,
                    "5. How We Use Information",
                    "Information may be used to:",
                    textColor,
                    subtitleColor,
                    bullets: const [
                      "Create and authenticate your account",
                      "Provide and maintain TalkLoop",
                      "Create and manage your anonymous profile",
                      "Match users for conversations",
                      "Apply blocking and reporting restrictions",
                      "Protect the service from abuse",
                      "Apply rate limits and security controls",
                      "Maintain and improve the application",
                    ],
                  ),
                  _section(
                    context,
                    "6. Data Storage",
                    "Your account and profile information is stored in our "
                        "application database. Block and report records are "
                        "also stored so that TalkLoop can enforce blocking, "
                        "reporting, and matching restrictions. TalkLoop's "
                        "anonymous profile information includes your anonymous "
                        "display name and avatar.",
                    textColor,
                    subtitleColor,
                  ),
                  _section(
                    context,
                    "7. Data Retention",
                    "Different information may be retained for different "
                        "periods depending on why it is needed. For example, "
                        "block and report records may need to remain available "
                        "to enforce safety and matching restrictions.\n\nThe "
                        "current application does not provide an account-deletion "
                        "feature through the API shown in this policy's "
                        "implementation, so we should not promise automatic "
                        "account deletion until that functionality is implemented.",
                    textColor,
                    subtitleColor,
                  ),
                  _section(
                    context,
                    "8. Security",
                    "We use authentication and access controls to protect "
                        "account-related operations. However, no internet-based "
                        "service can guarantee complete security.",
                    textColor,
                    subtitleColor,
                  ),
                  _section(
                    context,
                    "9. Your Choices",
                    "You can update your profile information through the "
                        "application. You can also change your anonymous "
                        "display name and avatar subject to TalkLoop's usage "
                        "limits. You can block or report users you do not want "
                        "to interact with.",
                    textColor,
                    subtitleColor,
                  ),
                  _section(
                    context,
                    "10. Changes to This Policy",
                    "We may update this Privacy Policy when TalkLoop's "
                        "features, data handling, or practices change. The "
                        "\"Last updated\" date will be updated when material "
                        "changes are made.",
                    textColor,
                    subtitleColor,
                  ),
                  _section(
                    context,
                    "11. Contact",
                    "For privacy-related questions or concerns, contact the "
                        "TalkLoop team through the support contact provided by "
                        "the application.",
                    textColor,
                    subtitleColor,
                    isLast: true,
                  ),_section(
                    context,
                    "Email: talkoop@gmail.com",
                    "Phone: +91 10223 78902",
                    textColor,
                    subtitleColor,
                    isLast: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _section(
      BuildContext context,
      String title,
      String body,
      Color textColor,
      Color subtitleColor, {
        List<String>? bullets,
        String? footer,
        List<String>? footerBullets,
        String? trailingText,
        bool isLast = false,
      }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: TextStyle(color: subtitleColor, fontSize: 14, height: 1.5),
          ),
          if (bullets != null) ...[
            const SizedBox(height: 8),
            ...bullets.map((b) => _bullet(b, subtitleColor)),
          ],
          if (footer != null) ...[
            const SizedBox(height: 10),
            Text(
              footer,
              style: TextStyle(color: subtitleColor, fontSize: 14, height: 1.5),
            ),
          ],
          if (footerBullets != null) ...[
            const SizedBox(height: 8),
            ...footerBullets.map((b) => _bullet(b, subtitleColor)),
          ],
          if (trailingText != null) ...[
            const SizedBox(height: 10),
            Text(
              trailingText,
              style: TextStyle(color: subtitleColor, fontSize: 14, height: 1.5),
            ),
          ],
        ],
      ),
    );
  }

  Widget _bullet(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("•  ", style: TextStyle(color: color, fontSize: 14)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: color, fontSize: 14, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}