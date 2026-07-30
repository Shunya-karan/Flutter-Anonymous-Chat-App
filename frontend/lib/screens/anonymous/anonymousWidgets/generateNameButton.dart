import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/services/anonymousService.dart';
import 'package:frontend/theme/appColor.dart';
import 'package:frontend/widgets/CustomWidgets/CustomeMessanger.dart';
import 'package:frontend/widgets/CustomWidgets/customeLoader.dart';

class Generatenamebutton extends StatefulWidget {
   final ValueChanged<String> onGenerateName;

   const Generatenamebutton({super.key,
      required this.onGenerateName
  });

  @override
  State<Generatenamebutton> createState() => _GeneratenamebuttonState();

}

class _GeneratenamebuttonState extends State<Generatenamebutton> {
  bool isGenerating = false;
  Future<void> generateName()async {
    try {
      setState(() {
        isGenerating = true;
      });
      final response = await AnonymousService.generateAnonymousName();
        final name = response.data["displayName"];
        widget.onGenerateName(name);

    } on DioException catch (e) {
      final message = e.response?.data["message"] ??
          "Something went wrong";
      CustomMessenger.show(context, message: message,bgColor: AppColors.error);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isGenerating = false;
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return  SizedBox(
        width: double.infinity,
        child:ElevatedButton.icon(
          onPressed: isGenerating ? null : generateName,
          icon: isGenerating
              ? const SizedBox(
            width: 18,
            height: 18,
            child: CustomLoader(),
          )
              : const Icon(Icons.casino),
          label: Text(
            isGenerating ? "Generating..." : "Generate New Name",
          ),
        )
    );
  }
}
