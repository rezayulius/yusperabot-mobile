import 'package:flutter/material.dart';
import 'package:yusperabot/components/custom_surfix_icon.dart';
import 'package:yusperabot/components/default_button.dart';
import 'package:yusperabot/components/form_error.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yusperabot/screens/registration_success/registration_success_screen.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class CompleteProfileForm extends StatefulWidget {
  final String
      userId; // Ubah menjadi required dengan menambahkan tanda wajib (? atau !) setelah tipe data

  CompleteProfileForm(
      {required this.userId}); // Tambahkan required pada konstruktor

  @override
  _CompleteProfileFormState createState() => _CompleteProfileFormState();
}

class _CompleteProfileFormState extends State<CompleteProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String?> errors = [];
  String? namaLengkap;
  String? alamat;
  String? kota;
  String? nomorHandphone;

  void addError({String? error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String? error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Save user profile data to Firebase or any other database
      // Example:
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .set({
        'namaLengkap': namaLengkap,
        'alamat': alamat,
        'kota': kota,
        'role': "Pelanggan",
        'nomorHandphone': nomorHandphone,
      });

      // Navigator.pushNamed(context, OtpScreen.routeName);
      Navigator.pushNamed(context, RegistrationSuccessScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildNamaLengkapFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildKotaFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildAlamatFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildNomorHandphoneFormField(),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "Continue",
            press: _saveProfile,
          ),
        ],
      ),
    );
  }

  TextFormField buildAlamatFormField() {
    return TextFormField(
      onSaved: (newValue) => alamat = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kAlamatNullError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kAlamatNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Alamat",
        hintText: "Masukkan alamat",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }

  TextFormField buildNomorHandphoneFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => nomorHandphone = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNomorHandphoneNullError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kNomorHandphoneNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Nomor Handphone",
        hintText: "Masukkan nomor handphone",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }

  TextFormField buildNamaLengkapFormField() {
    return TextFormField(
      onSaved: (newValue) => namaLengkap = newValue,
      decoration: InputDecoration(
        labelText: "Nama",
        hintText: "Masukkan nama lengkap",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildKotaFormField() {
    return TextFormField(
      onSaved: (newValue) => kota = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kKotaNullError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kKotaNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Kota",
        hintText: "Masukkan kota",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }
}
