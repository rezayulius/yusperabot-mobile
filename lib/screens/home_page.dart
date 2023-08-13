// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:yusperabot/screens/details_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(80), // Atur tinggi AppBar sesuai kebutuhan
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Padding(
            padding: EdgeInsets.only(
                top: 16), // Atur jarak atas (top padding) di sini
            child: Center(
              child: Image.asset(
                color: Colors.black,
                'assets/logo.png',
                width: 36,
                height: 36,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                // Aksi ketika tombol pencarian ditekan
              },
            ),
            IconButton(
              icon: Icon(
                Icons.notifications,
                color: Colors.white,
              ),
              onPressed: () {
                // Aksi ketika tombol notifikasi ditekan
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(5),
        child: ListView(
          children: [
            Text(
              "Make your \nhome feel comfortable",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit.\nPhasellus eget ligula euismod, commodo enim vel.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                ),
                // ignore: sized_box_for_whitespace
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 30, bottom: 25),
              child: SingleChildScrollView(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Fungsi yang akan dijalankan saat tombol 1 ditekan
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor:
                              Colors.white, // Warna teks pada tombol
                          textStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(
                                color: Colors.black), // Garis tepi tombol
                          ),
                        ),
                        child: Text('Promo'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          // Fungsi yang akan dijalankan saat tombol 1 ditekan
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor:
                              Colors.white, // Warna teks pada tombol
                          textStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(
                                color: Colors.black), // Garis tepi tombol
                          ),
                        ),
                        child: Text('Katalog'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Card(
              elevation: 3,
              child: Container(
                width: 200,
                height: 150,
                child: Image(
                  image: AssetImage("assets/logo.png"),
                  fit: BoxFit.contain,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 40),
            Text(
              "Why should you Choose us?",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit.\nPhasellus eget ligula euismod, commodo enim vel.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                ),
                // ignore: sized_box_for_whitespace
              ],
            ),
          ],
        ),
      ),
    );
  }
}
