import 'package:flutter/material.dart';
import 'package:yusperabot/screens/promo/components/promo_list.dart';
import '../../home/components/section_title.dart';
import 'promo_header.dart';
import 'subtittle.dart';
import 'image_banner.dart';
import '../../../size_config.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // PromoHeader(),
            SizedBox(height: getProportionateScreenWidth(10)),
            Subtittle(),
            ImageBanner(),
            // SizedBox(height: getProportionateScreenWidth(30)),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20)),
              child: SectionTitle(
                title: "Promo untuk kamu",
                press: () {},
              ),
            ),
            PromoList(),
            SizedBox(height: getProportionateScreenWidth(30)),
          ],
        ),
      ),
    );
  }
}
