import 'package:flutter/material.dart';
import 'package:online_class/core/utils/colors.dart';
import 'package:online_class/feature/auth/service/auth_method.dart';
import 'package:online_class/feature/home/app_main_screen.dart';
import 'package:online_class/route.dart';

import '../../../core/utils/utils.dart';

// Google Sign-In Screen
class GoogleLoginScreen extends StatefulWidget {
  const GoogleLoginScreen({super.key});

  @override
  State<GoogleLoginScreen> createState() =>
      _GoogleLoginScreenState();
}

class _GoogleLoginScreenState
    extends State<GoogleLoginScreen> {

  bool _isloading = false;

  Future<void> _signInWithGoogle() async {

    setState(() {
      _isloading = true;
    });

    try {

      final userCredential =
      await GoogleSignInService.signInWithGoogle();

      if (!mounted) return;

      if (userCredential != null) {

        // Navigate to Home Screen
        NavigationHelper.pushReplacement(
          context,
          const
          AppMainScreen(),


        );

        print(
          'user signed in: ${userCredential.user?.displayName}',
        );
      }

    } catch (e) {

      if (!mounted) return;

      showAppSnackbar(
        context: context,
        type: SnackbarType.error,
        description: "Google Login Failed",
      );

      print('sign in error: $e');

    } finally {

      if (mounted) {
        setState(() {
          _isloading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(

      backgroundColor: bodyColor,

      body: SafeArea(

        child: Column(

          children: [

            Image.asset(
              "assets/intropng.png",
              height: size.height * 0.56,
              fit: BoxFit.cover,
            ),

            SizedBox(
              height: size.height * 0.13,
            ),

            _isloading
                ? const CircularProgressIndicator()
                : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(

                  onPressed: _signInWithGoogle,

                  icon: Image.network(
                    'https://developers.google.com/identity/images/g-logo.png',
                    height: 25,
                    width: 40,
                  ),

                  label: const Text(
                    'Sign in with Google',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: appBarColor,

                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}