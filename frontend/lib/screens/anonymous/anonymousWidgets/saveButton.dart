import 'package:flutter/material.dart';
import 'package:frontend/widgets/CustomWidgets/customeLoader.dart';


class SaveButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final String buttonText;
  const SaveButton({super.key,
    required this.onPressed,
    required this.isLoading,
    required this.buttonText
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
          ):Text(buttonText)
      ),
    );
  }
}
