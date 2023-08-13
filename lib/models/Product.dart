import 'package:flutter/material.dart';

class Product {
  final int id;
  final String title, description, price;
  final List<String> images;
  final List<Color> colors;
  final double rating;
  final bool isFavourite, isPopular;

  Product({
    required this.id,
    required this.images,
    required this.colors,
    this.rating = 0.0,
    this.isFavourite = false,
    this.isPopular = false,
    required this.title,
    required this.price,
    required this.description,
  });
}

// Our demo Products

List<Product> demoProducts = [
  Product(
    id: 1,
    images: [
      "assets/images/kitchen_1.png",
      "assets/images/kitchen_2.png",
      "assets/images/kitchen_3.png",
    ],
    colors: [
      Color(0xFFF6625E),
      Color(0xFF836DB8),
      Color(0xFFDECB9C),
      Colors.white,
    ],
    title: "Kitchen Set",
    price: "1 Juta",
    description: "Kitchen set ini menerapkan model desain minimalis.",
    rating: 4.8,
    isFavourite: true,
    isPopular: true,
  ),
  Product(
    id: 2,
    images: [
      "assets/images/bed_1.png",
      "assets/images/bed_2.png",
      "assets/images/bed_3.png",
      "assets/images/bed_4.png",
    ],
    colors: [
      Color(0xFFF6625E),
      Color(0xFF836DB8),
      Color(0xFFDECB9C),
      Colors.white,
    ],
    title: "Bedroom Set",
    price: "2 Juta",
    description: "Bedroom set ini menerapkan model desain modern minimalis.",
    rating: 4.1,
    isPopular: true,
  ),
  Product(
    id: 3,
    images: [
      "assets/images/meet_1.png",
      "assets/images/meet_2.png",
      "assets/images/meet_3.png",
    ],
    colors: [
      Color(0xFFF6625E),
      Color(0xFF836DB8),
      Color(0xFFDECB9C),
      Colors.white,
    ],
    title: "Meeting Room",
    price: "1,5 Juta",
    description: "Meeting room ini menerapkan model desain modern minimalis.",
    rating: 4.1,
    isFavourite: true,
    isPopular: true,
  ),
  Product(
    id: 4,
    images: [
      "assets/images/logo.png",
    ],
    colors: [
      Color(0xFFF6625E),
      Color(0xFF836DB8),
      Color(0xFFDECB9C),
      Colors.white,
    ],
    title: "Coming Soon",
    price: "1 Juta",
    description: description,
    rating: 4.1,
    isFavourite: true,
  ),
];

const String description = "Coming Soon";
