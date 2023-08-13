import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:yusperabot/components/custom_surfix_icon.dart';
import 'package:yusperabot/components/default_button.dart';
import 'package:yusperabot/components/form_error.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yusperabot/screens/home/home_screen.dart';
import 'package:yusperabot/screens/order/components/promo_list.dart';
import 'package:yusperabot/screens/promo/components/promo_list.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class OrderForm extends StatefulWidget {
  @override
  _OrderFormState createState() => _OrderFormState();
}

class _OrderFormState extends State<OrderForm> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? orderId;
  double? panjangRuangan;
  double? lebarRuangan;
  String? pertanyaan1;
  String? pertanyaan2;
  String? pertanyaan3;
  String? pertanyaan4;
  DateTime? tanggalOrder;
  String? gambarDenah;
  String? status;
  String? promoId;
  String? selectedPromo;
  String? desainerId;
  String? estimasiPengerjaan;
  String? hasilDesain2d;
  String? hasilDesain3d;
  String? statusPembayaran;
  int? isNew = 1;
  int? nominalUangMuka = 0;
  int? nominalPelunasan = 0;
  final List<String?> errors = [];
  String? userId;

  String? promoItems;

  void handlePromoChanged(String? promoId) {
    setState(() {
      selectedPromo = promoId;
    });
  }

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

  String generateOrderId() {
    var uuid = Uuid();
    var timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    var orderId = 'PM$timestamp';
    return orderId;
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      // Mendapatkan informasi pengguna yang sedang login
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Mendapatkan data pengguna dari koleksi 'users' berdasarkan ID pengguna yang sedang login
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (userSnapshot.exists) {
          // Mendapatkan nilai dari field yang dibutuhkan
          // ...
          String orderId = generateOrderId();
          DateTime currentDate = DateTime.now(); // Mengambil waktu saat ini
          // Membuat dokumen baru di koleksi 'orders' dengan data pesanan dan informasi pengguna
          DocumentReference orderRef =
              await FirebaseFirestore.instance.collection('orders').add({
            'orderId': orderId, // Field order id
            'userId': user.uid, // Menyimpan ID pengguna sebagai relasi
            'panjangRuangan': panjangRuangan,
            'lebarRuangan': lebarRuangan,
            'pertanyaan1': pertanyaan1,
            'pertanyaan2': pertanyaan2,
            'pertanyaan3': pertanyaan3,
            'pertanyaan4': pertanyaan4,
            'tanggalOrder': currentDate,
            'gambar': gambarDenah,
            'status': 'Verifikasi Data',
            'promo_id': selectedPromo,
            'desainerId': "",
            'estimasiPengerjaan': "",
            'nominalUangMuka': nominalUangMuka,
            'nominalPelunasan': nominalPelunasan,
            'isNew': isNew,
            'hasilDesain2d': "",
            'hasilDesain3d': "",
            'statusPembayaran': "",
            'paymentProof': "",
            'linkDrive': "",
          });

          if (orderRef != null) {
            // Upload gambar ke Firebase Storage jika ada gambar yang dipilih
            if (gambarDenah != null) {
              try {
                // Membuat referensi file di Firebase Storage dengan menggunakan order id sebagai nama file
                Reference storageRef = FirebaseStorage.instance
                    .ref()
                    .child('order_images/$orderId.jpg');

                // Mengunggah gambar ke Firebase Storage
                UploadTask uploadTask = storageRef.putFile(File(gambarDenah!));
                TaskSnapshot uploadSnapshot =
                    await uploadTask.whenComplete(() {});

                // Mendapatkan URL gambar yang diunggah
                String imageUrl = await storageRef.getDownloadURL();

                // Menyimpan URL gambar ke dokumen pesanan
                await orderRef.update({'gambar': imageUrl});

                // Hapus gambar lokal setelah diunggah ke Firebase Storage
                File(gambarDenah!).delete();
              } catch (error) {
                // Menghandle kesalahan jika terjadi kesalahan saat mengunggah gambar
                print('Error uploading image: $error');
                // Tambahkan logika penanganan kesalahan sesuai kebutuhan Anda
              }
            }
            Navigator.pushNamed(context, HomeScreen.routeName);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor:
                    Colors.blue, // Mengubah warna latar belakang SnackBar
                content: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.white,
                    ), // Menambahkan ikon tanda centang
                    SizedBox(width: 10),
                    Text(
                      'Pesanan berhasil dibuat',
                      style: TextStyle(
                        color: Colors.white, // Mengubah warna teks
                        fontWeight:
                            FontWeight.bold, // Mengubah gaya teks menjadi bold
                      ),
                    ),
                  ],
                ),
                duration: Duration(seconds: 3), // Mengubah durasi SnackBar
                behavior: SnackBarBehavior
                    .floating, // Mengubah tampilan SnackBar menjadi floating
                shape: RoundedRectangleBorder(
                  // Mengubah bentuk SnackBar
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );

            // ...
            setState(() {
              _isLoading = false;
            });
          }
        } else {
          print('User data not found.');
        }
      } else {
        print('User not logged in.');
      }
    }
  }

  void _pickImage() async {
    final pickedImage =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        gambarDenah = pickedImage.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildPersonalDataSection(),
          SizedBox(height: getProportionateScreenHeight(30)),
          //buildPromoFormField(),\
          PromoListFormField(onPromoChanged: handlePromoChanged),
          //PromoListFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPanjangRuanganFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildLebarRuanganFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPertanyaan1FormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPertanyaan2FormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPertanyaan3FormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPertanyaan4FormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildGambarDenahFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          if (_isLoading)
            CircularProgressIndicator() // Tampilkan tampilan loading jika _isLoading true
          else
            DefaultButton(
              text: "Submit",
              press: _submitForm,
            ),
        ],
      ),
    );
  }

  Column buildPersonalDataSection() {
    return Column(
      children: [
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          initialValue: FirebaseAuth.instance.currentUser?.email,
          onSaved: (newValue) => email = newValue,
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: kEmailNullError);
            } else if (emailValidatorRegExp.hasMatch(value)) {
              removeError(error: kInvalidEmailError);
            }
          },
          validator: (value) {
            if (value!.isEmpty) {
              addError(error: kEmailNullError);
              return "";
            } else if (!emailValidatorRegExp.hasMatch(value)) {
              addError(error: kInvalidEmailError);
              return "";
            }
            return null;
          },
          decoration: InputDecoration(
            enabled: false,
            labelText: "Email",
            hintText: FirebaseAuth.instance.currentUser?.email,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
          ),
        ),
      ],
    );
  }

  Future<List> getPromoData() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('promo').get();
    List promoList = snapshot.docs.map((DocumentSnapshot document) {
      return document.get('promo_id') ?? '';
    }).toList();
    return promoList;
  }

  TextFormField buildPanjangRuanganFormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      onSaved: (newValue) => panjangRuangan = double.tryParse(newValue!),
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPanjangRuanganNullError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPanjangRuanganNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Panjang Ruangan (meter)",
        hintText: "Panjang ruangan..",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.square_foot),
      ),
    );
  }

  TextFormField buildLebarRuanganFormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      onSaved: (newValue) => lebarRuangan = double.tryParse(newValue!),
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kLebarRuanganNullError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kLebarRuanganNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Lebar Ruangan (meter)",
        hintText: "Lebar ruangan..",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.square_foot),
      ),
    );
  }

  DropdownButtonFormField buildPertanyaan1FormField() {
    return DropdownButtonFormField<String>(
      value: pertanyaan1,
      onChanged: (newValue) {
        setState(() {
          pertanyaan1 = newValue;
        });
      },
      decoration: InputDecoration(
        labelText: "Jenis Ruangan",
        hintText: "Pilih Jawaban",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      items: [
        DropdownMenuItem<String>(
          value: "Ruang Keluarga",
          child: Text("Ruang Keluarga"),
        ),
        DropdownMenuItem<String>(
          value: "Ruang Tengah",
          child: Text("Ruang Tengah"),
        ),
        DropdownMenuItem<String>(
          value: "Ruang Tamu",
          child: Text("Ruang Tamu"),
        ),
        DropdownMenuItem<String>(
          value: "Ruang Serba Guna",
          child: Text("Ruang Serba Guna"),
        ),
        DropdownMenuItem<String>(
          value: "Kamar Tidur",
          child: Text("Kamar Tidur"),
        ),
        DropdownMenuItem<String>(
          value: "Lainnya",
          child: Text("Lainnya"),
        ),
        // Tambahkan opsi pilihan lain sesuai kebutuhan Anda
      ],
    );
  }

  DropdownButtonFormField buildPertanyaan2FormField() {
    return DropdownButtonFormField<String>(
      value: pertanyaan2,
      onChanged: (newValue) {
        setState(() {
          pertanyaan2 = newValue;
        });
      },
      decoration: InputDecoration(
        labelText: "Kenapa memutuskan untuk\nmendesain rumah?",
        hintText: "Pilih Jawaban",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      isExpanded: true,
      items: [
        DropdownMenuItem<String>(
          value: "Saya baru pindah",
          child: Text("Saya baru pindah"),
        ),
        DropdownMenuItem<String>(
          value: "Butuh bantuan untuk mendekorasi ulang",
          child: Text("Butuh bantuan untuk mendekorasi ulang"),
        ),
        DropdownMenuItem<String>(
          value: "Butuh bantuan layout furniture",
          child: Text("Butuh bantuan layout furniture"),
        ),
        DropdownMenuItem<String>(
          value: "Lainnya",
          child: Text("Lainnya"),
        ),
        // Tambahkan opsi pilihan lain sesuai kebutuhan Anda
      ],
    );
  }

  DropdownButtonFormField buildPertanyaan3FormField() {
    return DropdownButtonFormField<String>(
      value: pertanyaan3,
      onChanged: (newValue) {
        setState(() {
          pertanyaan3 = newValue;
        });
      },
      decoration: InputDecoration(
        labelText: "Kondisi ruangan yang ditempati?",
        hintText: "Pilih Jawaban",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      isExpanded: true,
      items: [
        DropdownMenuItem<String>(
          value: "Ruangan kosong",
          child: Text("Ruangan kosong"),
        ),
        DropdownMenuItem<String>(
          value: "Terdapat beberapa furniture",
          child: Text("Terdapat beberapa furniture"),
        ),
        DropdownMenuItem<String>(
          value: "Sudah didekorasi",
          child: Text("Sudah didekorasi"),
        ),
        DropdownMenuItem<String>(
          value: "Lainnya",
          child: Text("Lainnya"),
        ),
        // Tambahkan opsi pilihan lain sesuai kebutuhan Anda
      ],
    );
  }

  DropdownButtonFormField buildPertanyaan4FormField() {
    return DropdownButtonFormField<String>(
      value: pertanyaan4,
      onChanged: (newValue) {
        setState(() {
          pertanyaan4 = newValue;
        });
      },
      decoration: InputDecoration(
        labelText: "Gaya desain yang \nmenggambarkan diri anda?",
        hintText: "Pilih Jawaban",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      isExpanded: true,
      items: [
        DropdownMenuItem<String>(
          value: "Modern Minimalis",
          child: Text("Modern Minimalis"),
        ),
        DropdownMenuItem<String>(
          value: "Pedesaan",
          child: Text("Pedesaan"),
        ),
        DropdownMenuItem<String>(
          value: "Trendi",
          child: Text("Trendi"),
        ),
        DropdownMenuItem<String>(
          value: "Tradisional",
          child: Text("Tradisional"),
        ),
        DropdownMenuItem<String>(
          value: "Klasik & Mewah",
          child: Text("Klasik & Mewah"),
        ),
        DropdownMenuItem<String>(
          value: "Lainnya",
          child: Text("Lainnya"),
        ),
        // Tambahkan opsi pilihan lain sesuai kebutuhan Anda
      ],
    );
  }

  Widget buildGambarDenahFormField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Upload Gambar Denah",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: getProportionateScreenHeight(10)),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: kSecondaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.camera_alt,
              color: kSecondaryColor,
              size: 50,
            ),
          ),
        ),
        Text(
          "*format file jpeg, jpg, png",
          style: TextStyle(fontSize: 8, fontWeight: FontWeight.w200),
        ),
        // SizedBox(height: getProportionateScreenHeight(10)),
        if (gambarDenah != null) Text("Gambar dipilih: $gambarDenah"),
      ],
    );
  }
}
