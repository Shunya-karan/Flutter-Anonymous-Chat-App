import 'package:flutter/material.dart';

class DisplayNameCard extends StatelessWidget {
  final String displayName;
  final VoidCallback onGenerate;
  const DisplayNameCard({super.key,
  required this.displayName,
    required this.onGenerate
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
               onPressed: onGenerate,
              icon: const Icon(Icons.casino),
              label: const Text("Generate New Name"),
          ),)
        ],
      ),
      ),
    );
  }
}
