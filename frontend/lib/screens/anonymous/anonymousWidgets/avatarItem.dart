import 'package:flutter/material.dart';

class AvatarItem extends StatelessWidget {
  final String avatar;
  final bool isSelected;
  final VoidCallback onTap;

  const AvatarItem({
    super.key,
    required this.avatar,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInBack,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withOpacity(0.3),
            width: isSelected ? 0.5 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? theme.colorScheme.primary.withOpacity(0.18)
                  : Colors.black.withOpacity(0.5),
              blurRadius: isSelected ? 14 : 6,
              spreadRadius: isSelected ? 1 : 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            AnimatedScale(
              duration: const Duration(milliseconds: 250),
              scale: isSelected ? 1.05 : 1,
              child: Image.asset(
                "assets/avatar/$avatar.png",
                fit: BoxFit.contain,
              ),
            ),

            if (isSelected)
              Positioned(
                bottom: 2,
                right: 1,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    size: 14,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}