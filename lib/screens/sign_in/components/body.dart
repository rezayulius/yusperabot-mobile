import 'package:flutter/material.dart';
import 'package:yusperabot/components/no_account_text.dart';
import 'package:yusperabot/components/socal_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:yusperabot/screens/home_page.dart';
import 'package:yusperabot/screens/sign_up/components/sign_up_form.dart';

import '../../../services/firebase_auth_service.dart';
import '../../../size_config.dart';
import '../../login_success/login_success_screen.dart';
import 'sign_form.dart';

Future<UserCredential> signInWithGoogle() async {
  // Buat instance objek GoogleSignIn
  final GoogleSignIn googleSignIn = GoogleSignIn();

  try {
    // Melakukan proses login menggunakan akun Google
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    // Jika login berhasil, lanjutkan dengan autentikasi Firebase
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Autentikasi dengan Firebase menggunakan credential dari Google
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Mengembalikan hasil autentikasi
      return userCredential;
    } else {
      throw FirebaseAuthException(
          message: 'Google sign in aborted by user', code: '');
    }
  } catch (e) {
    throw FirebaseAuthException(
        message: 'Failed to sign in with Google: $e', code: '');
  }
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                Text(
                  "Welcome Back",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(28),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Sign in with your email and password  \nor continue with social media",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                SignForm(),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocalCard(
                      icon: "assets/icons/google-icon.svg",
                      press: () async {
                        try {
                          // Memanggil metode signInWithGoogle
                          final UserCredential userCredential =
                              await signInWithGoogle();

                          // Jika berhasil login, lanjutkan dengan navigasi ke halaman beranda
                          if (userCredential.user != null) {
                            // ignore: use_build_context_synchronously
                            Navigator.pushNamed(
                                context, LoginSuccessScreen.routeName,
                                arguments: userCredential.user);
                          }
                        } catch (e) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Error"),
                              content:
                                  Text("Failed to sign in with Google: $e"),
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
                    SocalCard(
                      icon: "assets/icons/facebook-2.svg",
                      press: () {},
                    ),
                    SocalCard(
                      icon: "assets/icons/twitter.svg",
                      press: () {},
                    ),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                const NoAccountText(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
