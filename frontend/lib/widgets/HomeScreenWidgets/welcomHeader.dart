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
        Image.asset("assets/images/LOGO.png",height: 80,width: 90,),
        SizedBox(width: 5),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome Back",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              username,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        )),
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey.shade400,
          child: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
