import 'package:flutter/material.dart';
import 'package:yusperabot/screens/result/components/body.dart';

class ResultScreen extends StatelessWidget {
  static String routeName = "/result";

  final String orderId;

  ResultScreen({required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hasil Desain'),
      ),
      body: Body(orderId: orderId),
    );
  }
}
