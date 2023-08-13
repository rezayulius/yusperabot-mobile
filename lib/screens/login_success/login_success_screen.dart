import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yusperabot/screens/home/home_screen.dart';
import 'components/body.dart';

class LoginSuccessScreen extends StatelessWidget {
  static String routeName = "/login_success";
  final User user;

  LoginSuccessScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Menghapus riwayat navigasi dan mengarahkan kembali ke halaman Home
        Navigator.pushNamedAndRemoveUntil(
            context, HomeScreen.routeName, (route) => false);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: SizedBox(),
          title: Text("Login Success"),
        ),
        body: Body(user: user),
      ),
    );
  }
}
