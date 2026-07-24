import 'package:flutter/material.dart';
import 'package:frontend/theme/lightTheme.dart';

class Securityfooter extends StatelessWidget {
  const Securityfooter({super.key});



  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return SizedBox(
      width: double.infinity-10,
      child: Card(
        elevation: 1,
          shape:Theme.of(context).cardTheme.shape,

        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.lock,size: 20,),
              SizedBox(width: 5),
              Text("Anonymous",
                  style:Theme.of(context).textTheme.bodyMedium
              ),
              SizedBox(width: 20,),

              Icon(Icons.bolt,size: 20),
              SizedBox(width: 5),
              Text("Fast Match",
                  style:Theme.of(context).textTheme.bodyMedium
              ),
              SizedBox(width: 20,),

              Icon(Icons.shield,size: 20),
              SizedBox(width: 5),
              Text("Secure",
                  style:Theme.of(context).textTheme.bodyMedium
              ),
              SizedBox(width: 20,),
            ],
          ),
        ),
      ),
    );
  }
}
