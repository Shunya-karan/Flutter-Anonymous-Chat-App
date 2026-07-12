import 'package:flutter/material.dart';
import 'package:frontend/core/theme/lightTheme.dart';

class Securityfooter extends StatelessWidget {
  const Securityfooter({super.key});



  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
          ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.lock,size: 20,),
              SizedBox(width: 5),
              Text("Anonymous",
                  style:LightTheme.theme.textTheme.bodySmall),
              SizedBox(width: 20,),

              Icon(Icons.bolt,size: 20),
              SizedBox(width: 5),
              Text("Fast Match",
                  style:LightTheme.theme.textTheme.bodySmall),
              SizedBox(width: 20,),

              Icon(Icons.shield,size: 20),
              SizedBox(width: 5),
              Text("Secure",
                  style:LightTheme.theme.textTheme.bodySmall),
              SizedBox(width: 20,),
            ],
          ),
        ),
      ),
    );
  }
}
