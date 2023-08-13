import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PromoListFormField extends StatefulWidget {
  final void Function(String?) onPromoChanged;

  PromoListFormField({required this.onPromoChanged});
  @override
  _PromoListFormFieldState createState() => _PromoListFormFieldState();
}

class _PromoListFormFieldState extends State<PromoListFormField> {
  String? promoId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('promo').get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<DropdownMenuItem<String>> promoItems = [];

          for (DocumentSnapshot document in snapshot.data!.docs) {
            String promo = document.get('promo_id') ?? '';
            String promoName = document.get('nama') ?? '';
            promoItems.add(
              DropdownMenuItem<String>(
                value: promo,
                child: Text(promoName),
              ),
            );
          }

          return DropdownButtonFormField<String>(
            value: promoId,
            onChanged: (newValue) {
              setState(() {
                promoId = newValue;
                widget.onPromoChanged(
                    promoId); // Panggil callback dengan nilai promoId
              });
            },
            decoration: InputDecoration(
              labelText: "Promo",
              hintText: "Pilih Promo",
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            isExpanded: true,
            items: promoItems,
          );
        }
      },
    );
  }
}
