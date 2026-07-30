import 'package:flutter/material.dart';
import 'package:frontend/screens/anonymous/anonymousWidgets/generateNameButton.dart';

class DisplayNameCard extends StatelessWidget {
  final String displayName;
  final ValueChanged<String> onGenerateName;

  const DisplayNameCard({
    super.key,
    required this.displayName,
    required this.onGenerateName,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(16),
      ),
      child: Padding(padding: EdgeInsetsGeometry.all(30),
      child: Column(
          children: [
            Text("Anonymous Name",
            style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 16,),
            SelectableText(
              displayName.isEmpty
                  ?"Tap Generate"
                  :displayName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22
              ),
            ),
            SizedBox(height: 20,),
            Generatenamebutton(onGenerateName: onGenerateName)
        ],
      ),
      ),
    );
  }
}
