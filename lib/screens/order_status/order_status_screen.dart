import 'package:flutter/material.dart';
import 'package:yusperabot/components/coustom_bottom_nav_bar.dart';
import 'package:yusperabot/enums.dart';

import '../order_detail/order_detail_screen.dart';
import 'components/body.dart';

class OrderStatusScreen extends StatelessWidget {
  static String routeName = "/order_status";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(
        onOrderSelected: (orderId) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailScreen(orderId: orderId),
            ),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.profile),
    );
  }
}
