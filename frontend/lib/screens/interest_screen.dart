import 'package:flutter/material.dart';

class InterestScreen extends StatefulWidget {
  const InterestScreen({super.key});

  @override
  State<InterestScreen> createState() => _InterestScreenState();
}

class _InterestScreenState extends State<InterestScreen> {

  final List<String> interests=[
    "Coding",
    "Gaming",
    "Movies",
    "Anime",
    "Music",
    "Sports",
  ];
  List<String> selectedInterest=[];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Interest"),
      ),
      body: Column(
        children: [
          Expanded(child: ListView.builder(
              itemCount: interests.length,
              itemBuilder: (context,index){
                final interest=interests[index];
                return CheckboxListTile(
                    title: Text(interest),
                    value: selectedInterest.contains(interest), 
                    onChanged: (value){
                        setState(() {
                          if(value==true){
                            selectedInterest.add(interest);
                          }else{
                            selectedInterest.remove(interest);
                          }
                        });
                });
              }
              )
          ),
          Padding(padding: EdgeInsets.all(16),
          child: ElevatedButton(onPressed: (){
            Navigator.pop(context,selectedInterest);
          }, child: Text("Continue")
          ),
          ),

        ],
      ),
    );
  }
}
