import 'package:flutter/material.dart';
import 'avatarItem.dart';

class AvatarGrid extends StatelessWidget {
  final String? selectedAvatar;
  final ValueChanged<String> onAvatarSelected;

  AvatarGrid({
    super.key,
    required this.selectedAvatar,
    required this.onAvatarSelected,
  });

  final List<String> avatars =
  List.generate(12, (index) => "avatar${index + 1}");

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: avatars.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.9,
          ),
          itemBuilder: (context, index) {
            final avatar = avatars[index];

            return AvatarItem(
              avatar: avatar,
              isSelected: avatar == selectedAvatar,
              onTap: () => onAvatarSelected(avatar),
            );
          },
        ),
      ],
    );
  }
}