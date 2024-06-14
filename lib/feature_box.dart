import 'package:ai_voice_assistant/pallete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeatureBox extends StatelessWidget {
  final Color color;
  final String headerText;
  final String desc;
  const FeatureBox({
    super.key,
    required this.color,
    required this.headerText, required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 35,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(
            Radius.circular(15)
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20).copyWith(
            left: 15
        ),
        child: Column(
          children: [
            Align(alignment: Alignment.centerLeft,
              child: Text(headerText, style: const TextStyle(
                  fontFamily: 'CeraPro',
                  color: Pallete.blackColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18
              ),),
            ),

            const SizedBox(height: 3,),

            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Text(desc, style: const TextStyle(
                fontFamily: 'CeraPro',
                color: Pallete.blackColor,
              ),),
            ),

          ],
        ),
      ),
    );
  }
}
