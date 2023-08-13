import 'package:flutter/material.dart';
import 'package:yusperabot/components/coustom_bottom_nav_bar.dart';
import 'package:yusperabot/enums.dart';

import 'components/body.dart';

class CatalogScreen extends StatelessWidget {
  static String routeName = "/catalog";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.catalog),
    );
  }
}
