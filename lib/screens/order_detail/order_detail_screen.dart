import 'package:flutter/material.dart';
import 'package:yusperabot/components/coustom_bottom_nav_bar.dart';
import 'package:yusperabot/enums.dart';

import 'components/body.dart';

class OrderDetailScreen extends StatelessWidget {
  static String routeName = "/order_detail";

  final String orderId;

  const OrderDetailScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(orderId: orderId),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.profile),
    );
  }
}
