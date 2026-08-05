import 'package:flutter/material.dart';
import 'package:frontend/widgets/CustomWidgets/customTextfield.dart';

class ReportUserDialog extends StatefulWidget {
  const ReportUserDialog({super.key});

  @override
  State<ReportUserDialog> createState() => _ReportUserDialogState();
}

class _ReportUserDialogState extends State<ReportUserDialog> {
  String? selectedReason;
  final reasonController = TextEditingController();
  bool isOtherSelected = false;

  final reasons = [
    "Spam",
    "Harassment",
    "Hate Speech",
    "Inappropriate Content",
    "Fake Profile",
    "Other",
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Report User"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...reasons.map((reason) {
              return RadioListTile<String>(
                value: reason,
                groupValue: selectedReason,
                title: Text(reason),
                onChanged: (value) {
                  setState(() {
                    selectedReason = value;
                    isOtherSelected = value == "Other";
                  });

                  if (!isOtherSelected) {
                    reasonController.clear();
                  }
                },
              );
            }),

            if (isOtherSelected)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: CustomTextField(
                  controller: reasonController,
                  hintText: "Enter reason",
                ),
              ),
          ],
        )
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        FilledButton(
          onPressed: selectedReason == null
              ? null
              : () {
            if (selectedReason == "Other" &&
                reasonController.text.trim().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Please enter a reason."),
                ),
              );
              return;
            }
            final reason = selectedReason == "Other"
                ? reasonController.text.trim()
                : selectedReason!;

            Navigator.pop(context, reason);
          },
          child: const Text("Submit"),
        ),
      ],
    );
  }
}