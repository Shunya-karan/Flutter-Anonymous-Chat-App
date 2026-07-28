import 'package:flutter/material.dart';

class AvatarItem extends StatelessWidget {
  final String avatar;
  final bool isSelected;
  final VoidCallback onTap;
  
  const AvatarItem({super.key,
  required this.avatar,
    required this.isSelected,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    final theme= Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected
              ?theme.colorScheme.primary
              :theme.cardColor,
          borderRadius: BorderRadius.circular(16) ,
          border: Border.all(
            color: isSelected
                ?theme.colorScheme.primary
                :Colors.grey.shade300,
            width: isSelected?2.5:1
          )
        ),
        child: Image.asset("assets/avatar/$avatar.png",
        fit: BoxFit.contain,
        ),

      ),
    );
  }
}
