import 'package:flutter/material.dart';
import 'package:frontend/widgets/CustomWidgets/customeLoader.dart';


class SaveButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  const SaveButton({super.key,
    required this.onPressed,
    required this.isLoading
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(onPressed: isLoading?null:onPressed,
          child: isLoading
              ?SizedBox(
            width: 20,height: 20,child: CustomLoader(),
          ):Text("Save Profile")
      ),
    );
  }
}
