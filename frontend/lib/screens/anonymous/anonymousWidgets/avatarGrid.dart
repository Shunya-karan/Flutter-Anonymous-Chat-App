import 'package:flutter/material.dart';
import 'avatarItem.dart';


class AvatarGrid extends StatelessWidget {
  final String? selectedAvatar;
  final ValueChanged<String> onAvatarSelected;
   AvatarGrid({super.key,
  required this.selectedAvatar,
    required this.onAvatarSelected
  });

  final List<String>avatars = List.generate(12,
      (index)=>"avatar${index+1}"
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Choose Avatar",
        style: Theme.of(context).textTheme.titleMedium,),
        SizedBox(height: 16,),
        GridView.builder(
          shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: avatars.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16),
            itemBuilder: (context,index){
              final avatar = avatars[index];
              return AvatarItem(avatar: avatar,
                  isSelected: avatar==selectedAvatar,
                  onTap: ()=>onAvatarSelected(avatar));
            })
      ],
    );
  }
}
