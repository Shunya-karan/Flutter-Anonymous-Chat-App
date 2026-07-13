import 'package:flutter/material.dart';


class GenderSelector extends StatelessWidget  {
  final String?selectedGender;
  final ValueChanged<String>onChanged;
  const GenderSelector({super.key,
  required this.selectedGender,
    required this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: ["Male", "Female", "Other"].map((gender) {
        return ChoiceChip(
          label: Text(gender),
          selected: selectedGender == gender,
          onSelected: (_) {
              onChanged(gender);
          },
        );
      }).toList(),
  );}
}
