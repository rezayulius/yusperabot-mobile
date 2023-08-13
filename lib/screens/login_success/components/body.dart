import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:yusperabot/components/default_button.dart';
import 'package:yusperabot/screens/home/home_screen.dart';
import 'package:yusperabot/size_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Body extends StatelessWidget {
  final User user;

  Body({required this.user});
  // Mengambil data pengguna Google

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: SizeConfig.screenHeight * 0.04),
        Image.asset(
          "assets/images/success.png",
          height: SizeConfig.screenHeight * 0.4, // 40%
        ),
        SizedBox(height: SizeConfig.screenHeight * 0.08),
        Text(
          "Login Success",
          style: TextStyle(
            fontSize: getProportionateScreenWidth(30),
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: _getUserData(user.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final userData = snapshot.data!.data();
              if (userData != null) {
                // Pengguna login menggunakan email terdaftar
                return Column(
                  children: [
                    Text('Selamat datang, ${userData['namaLengkap']}'),
                    // Tambahkan informasi lain yang ingin ditampilkan
                  ],
                );
              } else {
                // Pengguna login menggunakan akun Google
                return Column(
                  children: [
                    Text('Selamat datang, ${user.displayName ?? ''}'),
                    // Tambahkan informasi lain yang ingin ditampilkan
                  ],
                );
              }
            }
          },
        ),
        Spacer(),
        SizedBox(
          width: SizeConfig.screenWidth * 0.6,
          child: DefaultButton(
            text: "Back to home",
            press: () {
              Navigator.pushNamed(context, HomeScreen.routeName);
            },
          ),
        ),
        Spacer(),
      ],
    );
  }
}

Future<DocumentSnapshot<Map<String, dynamic>>> _getUserData(
    String userId) async {
  final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
  final userData = await userDoc.get();
  return userData;
}
