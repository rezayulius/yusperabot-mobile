import 'package:flutter/material.dart';
import 'package:yusperabot/screens/cart/cart_screen.dart';

import '../../../size_config.dart';
// import 'icon_btn_with_counter.dart';
// import 'search_field.dart';

class PromoHeader extends StatelessWidget {
  const PromoHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 10), // Jarak antara logo dan teks
          Text(
            'Promo',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
