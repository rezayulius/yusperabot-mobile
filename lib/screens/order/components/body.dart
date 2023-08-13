import 'package:flutter/material.dart';
import 'package:yusperabot/components/socal_card.dart';
import 'package:yusperabot/constants.dart';
import 'package:yusperabot/size_config.dart';

import 'order_form.dart';

class Body extends StatelessWidget {
  final String? userId; // Tambahkan parameter userId

  Body({this.userId});
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
                SizedBox(height: SizeConfig.screenHeight * 0.04), // 4%
                Text("Formulir Pemesanan", style: headingStyle),
                const Text(
                  "Lengkapi data pemesanan sesuai dengan \nkebutuhan anda",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                OrderForm(),
                SizedBox(height: SizeConfig.screenHeight * 0.08),

                SizedBox(height: getProportionateScreenHeight(20)),
                Text(
                  'Pastikan semua data sudah sesuai.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.caption,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
