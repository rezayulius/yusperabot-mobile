import 'package:flutter/material.dart';
import 'package:yusperabot/size_config.dart';

class ImageBanner extends StatelessWidget {
  final List<String> imagePaths = [
    'assets/images/bed_1.png',
    'assets/images/bed_2.png',
    'assets/images/bed_3.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(getProportionateScreenWidth(20)),
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(20),
        vertical: getProportionateScreenWidth(15),
      ),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Image.asset(
              imagePaths[0],
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: getProportionateScreenWidth(10)),
          Expanded(
            child: Column(
              children: [
                Image.asset(
                  imagePaths[1],
                  width: double.infinity,
                  height: 95,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: getProportionateScreenWidth(10)),
                Image.asset(
                  imagePaths[2],
                  width: double.infinity,
                  height: 95,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
