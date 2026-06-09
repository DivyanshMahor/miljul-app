import 'package:flutter/material.dart';

//insted of using navigator every time we have create a common navigation helper
class NavigationHelper {

  //push a new screen
  static void push(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context)=> screen),);
  }

  //Replace current screen || wapesh ata hai
static void pushReplacement(BuildContext context, Widget screen) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> screen),);
}

}