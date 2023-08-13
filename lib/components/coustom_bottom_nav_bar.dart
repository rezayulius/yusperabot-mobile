import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yusperabot/screens/catalog/catalog_screen.dart';
import 'package:yusperabot/screens/home/home_screen.dart';
import 'package:yusperabot/screens/order/order_screen.dart';
import 'package:yusperabot/screens/profile/profile_screen.dart';
import 'package:yusperabot/screens/promo/promo_screen.dart';

import '../constants.dart';
import '../enums.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    Key? key,
    required this.selectedMenu,
  }) : super(key: key);

  final MenuState selectedMenu;

  @override
  Widget build(BuildContext context) {
    final Color inActiveIconColor = Color(0xFFB6B6B6);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  (Icons.home_outlined),
                  color: MenuState.home == selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () =>
                    Navigator.pushNamed(context, HomeScreen.routeName),
              ),
              IconButton(
                icon: Icon(
                  (Icons.checklist_outlined),
                  color: MenuState.promo == selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () =>
                    Navigator.pushNamed(context, PromoScreen.routeName),
              ),
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/User Icon.svg",
                  color: MenuState.profile == selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () =>
                    Navigator.pushNamed(context, ProfileScreen.routeName),
              ),
              IconButton(
                icon: Icon(Icons.list_outlined),
                color: MenuState.order == selectedMenu
                    ? kPrimaryColor
                    : inActiveIconColor,
                onPressed: () async =>
                    Navigator.pushNamed(context, OrderScreen.routeName),
              ),
              IconButton(
                icon: Icon(Icons.image),
                color: MenuState.catalog == selectedMenu
                    ? kPrimaryColor
                    : inActiveIconColor,
                onPressed: () =>
                    Navigator.pushNamed(context, CatalogScreen.routeName),
              ),
            ],
          )),
    );
  }
}
