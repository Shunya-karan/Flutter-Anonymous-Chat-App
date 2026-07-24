import 'package:flutter/material.dart';
import 'package:frontend/core/theme/appColor.dart';

class OnlineUsersCard extends StatelessWidget {
  final int onlineUsers;

  const OnlineUsersCard({
    super.key,
    required this.onlineUsers,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: Theme.of(context).cardTheme.color,
        shape: Theme.of(context).cardTheme.shape,
      child: Padding(
        padding:
        const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),

            const SizedBox(width: 12),

            Text(
              "$onlineUsers people are online right now",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}