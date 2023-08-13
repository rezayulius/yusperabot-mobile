import 'package:flutter/material.dart';

import 'components/body.dart';

class CompleteProfileScreen extends StatelessWidget {
  static String routeName = "/complete_profile";
  final String? userId; // Tambahkan parameter userId

  CompleteProfileScreen(
      {this.userId}); // Tambahkan parameter userId pada konstruktor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      //body: Body(userId: userId),
      body: Body(userId: userId!),
      // Teruskan userId ke Body
    );
  }
}
