import 'package:cloud_firestore/cloud_firestore.dart';

class Result {
  final String orderId;
  final String image;
  final String panjangRuangan;
  final String lebarRuangan;
  final Timestamp tanggalOrder;
  final String linkDrive;
  final String title, description;
  final int price;

  Result({
    required this.orderId,
    required this.image,
    required this.panjangRuangan,
    required this.lebarRuangan,
    required this.tanggalOrder,
    required this.title,
    required this.linkDrive,
    required this.price,
    required this.description,
  });

  factory Result.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return Result(
      orderId: data?['orderId'] ?? '',
      image: data?['hasilDesain2d'] ??
          '', // Gunakan nilai default jika data['hasilDesain2D'] adalah null
      panjangRuangan: data?['panjangRuangan'] ??
          '', // Gunakan nilai default jika data['hasilDesain2D'] adalah null
      lebarRuangan: data?['lebarRuangan'] ??
          '', // Gunakan nilai default jika data['hasilDesain2D'] adalah null
      tanggalOrder: data?['tanggalOrder'] ??
          '', // Gunakan nilai default jika data['hasilDesain2D'] adalah null
      linkDrive: data?['linkDrive'] ??
          '', // Gunakan nilai default jika data['hasilDesain2D'] adalah null
      title: data?['orderId'] ??
          '', // Gunakan nilai default jika data['orderId'] adalah null
      description: data?['orderId'] ??
          '', // Gunakan nilai default jika data['orderId'] adalah null
      price: data?['nominalPelunasan'] ??
          0, // Gunakan nilai default jika data['nominalPelunasan'] adalah null
    );
  }
}
