import 'package:flutter/material.dart';


class WelcomeHeader extends StatelessWidget {
  final String username;
  final String?profileImage;
  const WelcomeHeader({super.key,
     this.profileImage,
    required this.username
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 39,
            backgroundImage:
            profileImage !=null?NetworkImage(profileImage!):null,
          child: profileImage==null?Icon(Icons.person):null,
        ),
        SizedBox(width: 15),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome Back ",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium,
            ),
            const SizedBox(height: 4),
            Text(
              username,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall,
            ),
          ],
        )),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.settings),
        ),
      ],
    );
  }
}
