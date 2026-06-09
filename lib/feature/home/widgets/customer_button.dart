import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsetsGeometry.all(25),
    child: SizedBox(
      width: double.maxFinite,
      child: ElevatedButton(

        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(15),
          )
        ),
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(text,style:
                    TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white
                    ),),
          )),
    ),
    );
  }
}
