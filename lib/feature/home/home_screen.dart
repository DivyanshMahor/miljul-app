import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:online_class/core/utils/colors.dart';
import 'package:online_class/feature/home/new_meeting_screen.dart';
import 'package:online_class/route.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 130,
            width: double.maxFinite,
            color: appBarColor,
            child: Padding(
              padding: EdgeInsetsGeometry.only(left: 30, top: 30),
              child: Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          FirebaseAuth.instance.currentUser!.photoURL ?? "",
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 10),
                  Text(
                    "Home",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 30),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              meetFeatures(
                Colors.orangeAccent,
                FaIcon(FontAwesomeIcons.video),
                "Meet",
                () {
                  NavigationHelper.push(context, NewMeetingScreen());
                },
              ),

              meetFeatures(
                Colors.blue,
                FaIcon(FontAwesomeIcons.solidSquarePlus),
                "Join",
                () {},
              ),

              meetFeatures(
                Colors.blue,
                FaIcon(FontAwesomeIcons.calendarDay),
                "Schedule",
                () {},
              ),

              meetFeatures(
                Colors.blue,
                FaIcon(FontAwesomeIcons.share),
                "Share",
                () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  GestureDetector meetFeatures(
    Color color,
    Widget icon,
    String name,
    VoidCallback onTab,
  ) {
    return GestureDetector(
      onTap: onTab,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 65,
            width: 65,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: color,
            ),

            child: Center(
                child: IconTheme(data: const IconThemeData(
                  color: Colors.white, size: 28,
                ), child: icon)

            ),
          ),
          const SizedBox(height: 5),
          Text(name),
        ],
      ),
    );
  }
}
