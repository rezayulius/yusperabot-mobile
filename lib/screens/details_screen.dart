// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        leading: Icon(
          Icons.arrow_back_ios_new,
          size: 20,
        ),
        elevation: 0,
        actions: const [
          Padding(
            padding: const EdgeInsets.only(top: 17, bottom: 17, right: 20),
            child: Icon(
              Icons.favorite_border,
              size: 20,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Transform(
              transform: Matrix4.identity()..rotateZ(5 * 3.1415927 / 180),
              child: Image.asset('assets/logo.png'),
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              'Cool Armchair',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
            ),
            SizedBox(
              height: 10,
            ),
            const Text(
              'Cool Armchair from indonesia yang menyatakan kemerdekaan indonesia abadi selamat aman sentosa',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 40,
                  width: 120,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(25)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Icon(
                            Icons.add,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        Text(
                          'Buat Pesanan',
                          style: TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                Column(
                  children: const [
                    Text(
                      'Harga',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      'Rp. 1 Juta',
                      style:
                          TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                    )
                  ],
                ),
                SizedBox(
                  width: 30,
                ),
                Container(
                  height: 60,
                  width: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(50)),
                      color: Colors.black26),
                  child: Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                    size: 25,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
