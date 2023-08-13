import 'dart:ui';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class PromoDetail {
  final String title;
  final String description1;
  final String description2;
  final String description3;
  final String description4;
  final int price;

  PromoDetail({
    required this.title,
    required this.description1,
    required this.description2,
    required this.description3,
    required this.description4,
    required this.price,
  });
}

class PromoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(getProportionateScreenWidth(20)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(
              sigmaX: 12,
              sigmaY: 12), // Atur tingkat blur sesuai kebutuhan Anda
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/meet_3.png'), // Ganti dengan path gambar yang diinginkan
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance.collection('promo').get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final promoDocs = snapshot.data!.docs;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: promoDocs.length,
                    itemBuilder: (context, index) {
                      final promoData =
                          promoDocs[index].data() as Map<String, dynamic>;
                      final promoTitle = promoData['nama'] as String?;
                      final promoDescription = promoData['jenis'] as String?;
                      final promoIcon = const Icon(Icons.discount);

                      return Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: getProportionateScreenWidth(10),
                          horizontal: getProportionateScreenWidth(20),
                        ),
                        child: Card(
                          color: Colors.white,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              hintColor: kPrimaryColor,
                              unselectedWidgetColor: Colors.black,
                            ),
                            child: ExpansionTile(
                              leading: promoIcon != null
                                  ? Icon(
                                      Icons.discount,
                                      color: Colors.red,
                                      size: 32,
                                    )
                                  : null,
                              title: Container(
                                child: promoTitle != null
                                    ? Text(
                                        promoTitle,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize:
                                              getProportionateScreenWidth(16),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : null,
                              ),
                              subtitle: promoDescription != null
                                  ? Text(
                                      promoDescription,
                                      style: TextStyle(
                                        fontSize:
                                            getProportionateScreenWidth(12),
                                        fontWeight: FontWeight.w300,
                                      ),
                                    )
                                  : null,
                              children: [
                                buildPromoDetail(promoData),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPromoDetail(Map<String, dynamic> promoData) {
    final promoDetail = PromoDetail(
      title: promoData['nama'] ?? '',
      description1: promoData['deskripsi1'] ?? '',
      description2: promoData['deskripsi2'] ?? '',
      description3: promoData['deskripsi3'] ?? '',
      description4: promoData['deskripsi4'] ?? '',
      price: promoData['harga'] ?? 0,
    );

    final priceFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(20),
        vertical: getProportionateScreenWidth(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Harga: ${priceFormat.format(promoDetail.price)}',
            style: TextStyle(
              fontSize: getProportionateScreenWidth(14),
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: getProportionateScreenWidth(10)),
          Divider(
            // Tambahkan divider untuk memisahkan informasi
            height: 1,
            color: Colors.grey,
          ),
          SizedBox(height: getProportionateScreenWidth(10)),
          Text(
            promoDetail.description1,
            style: TextStyle(
              fontSize: getProportionateScreenWidth(14),
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: getProportionateScreenWidth(5)),
          Text(
            promoDetail.description2,
            style: TextStyle(
              fontSize: getProportionateScreenWidth(14),
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: getProportionateScreenWidth(5)),
          Text(
            promoDetail.description3,
            style: TextStyle(
              fontSize: getProportionateScreenWidth(14),
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: getProportionateScreenWidth(5)),
          Text(
            promoDetail.description4,
            style: TextStyle(
              fontSize: getProportionateScreenWidth(14),
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: getProportionateScreenWidth(5)),
          // Tambahkan informasi lainnya mengenai promo jika ada
        ],
      ),
    );
  }
}
