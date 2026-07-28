import 'package:flutter/material.dart';
import 'package:frontend/screens/anonymous/anonymousWidgets/avatarGrid.dart';

class anonymousProfilescreen extends StatefulWidget {

  const anonymousProfilescreen({super.key});

  @override
  State<anonymousProfilescreen> createState() => _anonymousProfilescreenState();
}

class _anonymousProfilescreenState extends State<anonymousProfilescreen> {
  String? selectedAvatar;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Anonymous Profile"),
        centerTitle: true,
      ),
      body: SafeArea(
          child:SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  child: AvatarGrid(selectedAvatar: selectedAvatar,
                      onAvatarSelected: (avatar){
                    setState(() {
                      selectedAvatar=avatar;
                    });
                      }),
                )
              ],
            ),
          )
      ),
    );
  }
}
