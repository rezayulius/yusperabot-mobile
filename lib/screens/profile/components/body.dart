import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:yusperabot/screens/order_status/order_status_screen.dart';
import 'package:yusperabot/screens/sign_in/sign_in_screen.dart';

import 'profile_menu.dart';
import 'profile_pic.dart';

class Body extends StatelessWidget {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            ProfilePic(),
            SizedBox(height: 20),
            // ProfileMenu(
            //   text: "My Account",
            //   icon: "assets/icons/User Icon.svg",
            //   press: () => {},
            // ),
            ProfileMenu(
              text: "Order Status",
              icon: "assets/icons/Bell.svg",
              press: () {
                Navigator.pushNamed(context, OrderStatusScreen.routeName);
              },
            ),
            // ProfileMenu(
            //   text: "Settings",
            //   icon: "assets/icons/Settings.svg",
            //   press: () {},
            // ),
            // ProfileMenu(
            //   text: "Help Center",
            //   icon: "assets/icons/Question mark.svg",
            //   press: () {},
            // ),
            ProfileMenu(
              text: "Log Out",
              icon: "assets/icons/Log out.svg",
              press: () async {
                try {
                  // Logout dari akun Google
                  await googleSignIn.signOut();

                  // Logout dari Firebase Auth
                  await auth.signOut();

                  // Kembali ke halaman login atau halaman awal aplikasi
                  // Sesuaikan dengan kebutuhan aplikasi Anda
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    SignInScreen.routeName,
                    (route) => false,
                  );
                } catch (e) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Error"),
                      content: Text("Failed to sign out: $e"),
                      actions: [
                        ElevatedButton(
                          child: const Text("OK"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
