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
        Stack(
          children:[
            CircleAvatar(
            radius: 35,
              backgroundImage:
              profileImage !=null?NetworkImage(profileImage!):null,
            child: profileImage==null?Icon(Icons.person):null,
          ),
            Positioned(
              bottom: 2,
              right: 2,
              child: Container(
                height: 16,
                width: 16,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
              ),
            ),
          ]
        ),
        SizedBox(width: 15),
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
                  .titleLarge,
            ),
          ],
        )),
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey.shade400,
          child: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu),
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
