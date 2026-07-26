import 'package:flutter/material.dart';

class ChatAppbar extends StatelessWidget implements PreferredSizeWidget{
  final String strangerName;
  final String? profileImage;
  final bool isOnline;
  final VoidCallback onSkip;

  const ChatAppbar({
    super.key,
    required this.strangerName,
    this.profileImage,
    required this.isOnline,
    required this.onSkip,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final hashIamge = profileImage?.isNotEmpty??false;
    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 1,
        title: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
           children: [
             // SizedBox(width: 5,),
             //profileImage
             CircleAvatar(
               radius: 22,
               backgroundImage: hashIamge?NetworkImage(profileImage!):null,
               child: !hashIamge
               ?Icon(Icons.person_outlined):null,
             ),
             SizedBox(width: 12,),
             //Name
             Expanded(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Text(strangerName,
                       maxLines: 1,
                     overflow: TextOverflow.ellipsis,
                       style: Theme.of(context).textTheme.titleMedium,
                     ),
                     SizedBox(height: 2,),
                     Row(
                       children: [
                         Container(
                           width: 8,
                           height: 8,
                           decoration: BoxDecoration(
                             color: isOnline
                                 ? Colors.green
                                 : Colors.red,
                             shape: BoxShape.circle,
                           ),
                         ),

                         const SizedBox(width: 6),

                         Text(
                           isOnline ? "Online" : "Offline",
                           style: Theme.of(context)
                               .textTheme
                               .bodySmall,
                         ),
                       ],
                     ),
                   ],
                 )
             ),
           ],
          ),
        ),
      actions: [
        TextButton.icon(onPressed: onSkip,
            icon: Icon(Icons.skip_next),
            label: Text("Skip"))
      ],
    );
  }
}
