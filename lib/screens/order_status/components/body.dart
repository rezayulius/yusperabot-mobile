import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../size_config.dart';
import 'order_card.dart';

class Body extends StatefulWidget {
  final Function(String) onOrderSelected; // Tambahkan properti ini

  const Body({Key? key, required this.onOrderSelected}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final CollectionReference ordersCollection =
      FirebaseFirestore.instance.collection('orders');
  final FirebaseAuth auth = FirebaseAuth.instance;

  List<DocumentSnapshot> orders = [];

  @override
  Widget build(BuildContext context) {
    final User? currentUser = auth.currentUser;
    final String? currentUserId = currentUser?.uid;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: getProportionateScreenWidth(20)),
      child: RefreshIndicator(
        onRefresh: () async {
          // Ambil data terbaru dari Firestore
          final refreshedData = await ordersCollection
              .where('userId', isEqualTo: currentUserId)
              .get();

          // Perbarui tampilan dengan data terbaru
          setState(() {
            final refreshedOrders = refreshedData.docs;
            orders.clear();
            orders.addAll(refreshedOrders);
          });
        },
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(getProportionateScreenWidth(20)),
              padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20),
                vertical: getProportionateScreenWidth(15),
              ),
              decoration: BoxDecoration(
                color: Color(0xFF4A3298),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text.rich(
                TextSpan(
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  children: [
                    TextSpan(
                      text: "Status Pesanan\n",
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(16),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text:
                          "Desain interior dan pembuatan furniture dengan kualitas bagus dan harga terjangkau.",
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(10),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: ordersCollection
                    .where('userId', isEqualTo: currentUserId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final orders = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: GestureDetector(
                            onTap: () {
                              final orderId = order['orderId'];
                              widget.onOrderSelected(orderId);
                            },
                            child: OrderCard(
                              order: order,
                              index: index += 1,
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
