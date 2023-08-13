import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yusperabot/components/default_button.dart';
import 'package:yusperabot/size_config.dart';

import '../../../models/Result.dart';
import '../../order/order_screen.dart';
import '../../order_detail/components/examples/localandwebobjectsexample.dart';
import 'color_dots.dart';
import 'product_description.dart';
import 'top_rounded_container.dart';
import 'product_images.dart';

class Body extends StatefulWidget {
  final String orderId;

  const Body({Key? key, required this.orderId}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  DocumentSnapshot<Map<String, dynamic>>? orderSnapshot;

  @override
  void initState() {
    super.initState();
    getOrderDetails(); // Panggil fungsi getOrderDetails() di initState()
  }

  Future<void> getOrderDetails() async {
    try {
      final orderQuerySnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('orderId', isEqualTo: widget.orderId)
          .get();

      if (orderQuerySnapshot.docs.isNotEmpty) {
        setState(() {
          orderSnapshot = orderQuerySnapshot.docs.first;
        });
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    void _navigateTo3DDesign() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              LocalAndWebObjectsWidget(orderId: widget.orderId),
        ),
      );
    }

    return orderSnapshot != null
        ? ListView(
            children: [
              ProductImages(result: Result.fromSnapshot(orderSnapshot!)),
              TopRoundedContainer(
                color: Colors.white,
                child: Column(
                  children: [
                    ProductDescription(
                      result: Result.fromSnapshot(orderSnapshot!),
                      pressOnSeeMore: () {},
                    ),
                    // SizedBox(height: 140),
                    TopRoundedContainer(
                      color: Color(0xFFF6F7F9),
                      child: Column(
                        children: [
                          ColorDots(
                              result: Result.fromSnapshot(orderSnapshot!)),
                          TopRoundedContainer(
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: SizeConfig.screenWidth * 0.15,
                                right: SizeConfig.screenWidth * 0.15,
                                bottom: getProportionateScreenWidth(10),
                                top: getProportionateScreenWidth(15),
                              ),
                              child: ElevatedButton(
                                onPressed: _navigateTo3DDesign,
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.orange,
                                  onPrimary: Colors.white,
                                  elevation: 5,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Text('Lihat Hasil AR'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
