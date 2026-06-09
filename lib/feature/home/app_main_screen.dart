import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:online_class/core/utils/colors.dart';
import 'package:online_class/feature/home/home_screen.dart';
import 'package:online_class/feature/home/profile_screen.dart';


class AppMainScreen extends StatefulWidget {
  const AppMainScreen({super.key});

  @override
  State<AppMainScreen> createState() => _AppMainScreenState();
}

class _AppMainScreenState extends State<AppMainScreen> {
  int currentIndex = 0;
  final List<Widget> pages = [
    HomeScreen(),
    Center(child: Text("Chats"),),
    Center(child: Text("Settings"),),
    ProfileScreen(),


  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyColor,
      body: pages[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.blue,
          iconSize: 20,
          unselectedItemColor: Colors.black,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          currentIndex: currentIndex,
          onTap: (value) => setState(()=>currentIndex=value ),


          
          
          items: [

        BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.houseChimney ), label: "Home" ),
        BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.solidMessage), label: "Chats" ),
        BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.gear), label: "Settings" ),
        BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.user ),  label: "Profile"),
      ]),

    );
  }
}