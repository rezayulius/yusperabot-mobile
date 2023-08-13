import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/services.dart';

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../size_config.dart';
import '../../result/result_screen.dart';
import 'examples/localandwebobjectsexample.dart';

class Body extends StatefulWidget {
  final String orderId;

  const Body({Key? key, required this.orderId}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final CollectionReference ordersCollection =
      FirebaseFirestore.instance.collection('orders');
  final FirebaseAuth auth = FirebaseAuth.instance;
  final ImagePicker _imagePicker = ImagePicker();

  late ArCoreController arCoreController;

  DocumentSnapshot? orderSnapshot;

  File? _paymentProofImage;

  void _removePaymentProofImage() {
    setState(() {
      _paymentProofImage = null;
    });
  }

  Future<void> _uploadPaymentProof() async {
    try {
      final User? currentUser = auth.currentUser;
      final String? currentUserId = currentUser?.uid;

      if (currentUserId != null && _paymentProofImage != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('payment_proofs')
            .child('${widget.orderId}.jpg');

        final uploadTask = storageRef.putFile(_paymentProofImage!);
        final snapshot = await uploadTask.whenComplete(() {});
        final downloadUrl = await snapshot.ref.getDownloadURL();

        final orderQuerySnapshot = await ordersCollection
            .where('userId', isEqualTo: currentUserId)
            .where('orderId', isEqualTo: widget.orderId)
            .limit(1)
            .get();

        if (orderQuerySnapshot.docs.isNotEmpty) {
          final orderDoc = orderQuerySnapshot.docs.first;
          final orderId = orderDoc.id;

          await ordersCollection.doc(orderId).update({
            'paymentProof': downloadUrl,
            'isPaid': 1,
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bukti pembayaran berhasil diunggah')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Terjadi kesalahan saat mengunggah bukti pembayaran')),
        );
      }
    } catch (error) {
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Terjadi kesalahan saat mengunggah bukti pembayaran')),
      );
    }
  }

  Future<void> _pickPaymentProofImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _paymentProofImage = File(pickedFile.path);
      });
    }
  }

  List<Map<String, dynamic>> statusHistory = [
    {'status': 'Verifikasi Data', 'icon': Icons.check, 'completed': false},
    {
      'status': 'Proses Pembayaran',
      'icon': Icons.pending_actions,
      'completed': false
    },
    {
      'status': 'Proses Desain',
      'icon': Icons.pending_actions,
      'completed': false
    },
    {'status': 'Selesai', 'icon': Icons.check, 'completed': false},
  ];

  @override
  void initState() {
    super.initState();

    getOrderDetails();
  }

  Future<void> getOrderDetails() async {
    try {
      final User? currentUser = auth.currentUser;
      final String? currentUserId = currentUser?.uid;

      if (widget.orderId.isNotEmpty) {
        final orderQuerySnapshot = await ordersCollection
            .where('userId', isEqualTo: currentUserId)
            .where('orderId', isEqualTo: widget.orderId)
            .limit(1)
            .get();

        if (orderQuerySnapshot.docs.isNotEmpty) {
          orderSnapshot = orderQuerySnapshot.docs.first;
          updateStatusHistory(); // Perbarui status pesanan
          setState(() {}); // Perbarui tampilan setelah mendapatkan data pesanan
        }
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void updateStatusHistory() {
    // Perbarui status selesai berdasarkan status pesanan
    for (int i = 0; i < statusHistory.length; i++) {
      if (statusHistory[i]['status'] == orderSnapshot!['status']) {
        statusHistory[i]['completed'] = true;
        break;
      }
    }
  }

  Color getStatusColor(String status) {
    if (status == 'Verifikasi Data' && statusHistory[0]['completed']) {
      return Colors.blue;
    } else if (status == 'Proses Pembayaran' && statusHistory[1]['completed']) {
      return Colors.blue;
    } else if (status == 'Proses Desain' && statusHistory[2]['completed']) {
      return Colors.blue;
    } else if (status == 'Selesai' && statusHistory[3]['completed']) {
      return Colors.green;
    } else {
      return Colors.grey.shade300;
    }
  }

  IconData getStatusIcon(String status) {
    if (status == 'Verifikasi Data' && statusHistory[0]['completed']) {
      return Icons.pending_actions;
    } else if (status == 'Proses Pembayaran' && statusHistory[1]['completed']) {
      return Icons.pending_actions;
    } else if (status == 'Proses Desain' && statusHistory[2]['completed']) {
      return Icons.pending_actions;
    } else if (status == 'Selesai' && statusHistory[3]['completed']) {
      return Icons.check;
    } else {
      return Icons.circle_outlined;
    }
  }

  void _open2DPreview() async {
    // Ambil URL gambar dari Firestore, gantikan "orderSnapshot" dengan data dari Firestore sesuai dengan struktur Anda
    final orderQuerySnapshot = await ordersCollection
        .where('orderId', isEqualTo: widget.orderId)
        .limit(1)
        .get();
    orderSnapshot = orderQuerySnapshot.docs.first;
    String imageUrl = orderSnapshot!['hasilDesain2d'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Expanded(
                child: Text(
                  'Preview Hasil Desain',
                  textAlign: TextAlign.center,
                ),
              ),
              Divider(), // Garis pemisah (divider) antara judul dan konten
            ],
          ),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 0.2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }

  // Function to handle the navigation to the 3D design screen
  void _navigateTo3DDesign() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocalAndWebObjectsWidget(orderId: widget.orderId),
      ),
    );
  }

  void _navigateToProductResult() {
    if (orderSnapshot!['statusPembayaran'] == 'Lunas') {
      // Logika untuk menampilkan hasil desain jika pembayaran sudah lunas
      // Contoh: Navigasi ke layar tampilan hasil desain
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(orderId: widget.orderId),
        ),
      );
    } else {
      // Jika pembayaran belum lunas, tampilkan pesan atau peringatan
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Pembayaran Belum Lunas'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Anda harus melunasi pembayaran terlebih dahulu untuk melihat hasil desain.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  primary: Colors.white,
                ),
                child: Text('OK'),
              ),
            ],
          ),
        ),
      );
    }
  }

  void _showPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Pembayaran Belum Lunas'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Anda harus melunasi pembayaran terlebih dahulu untuk melihat hasil desain.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                primary: Colors.white,
              ),
              child: Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: getProportionateScreenWidth(20)),
      child: orderSnapshot != null
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section: Status Pesanan
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(getProportionateScreenWidth(20)),
                    padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(20),
                      vertical: getProportionateScreenWidth(15),
                    ),
                    decoration: BoxDecoration(
                      color: getStatusColor(orderSnapshot!['status']),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Detail Pesanan",
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(16),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Icon(
                          getStatusIcon(orderSnapshot!['status']),
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  DefaultTabController(
                    length: 3, // Jumlah tab menu
                    child: Column(
                      children: [
                        TabBar(
                          labelColor:
                              Colors.black, // Ubah warna teks menjadi hitam
                          tabs: [
                            Tab(text: 'Status'),
                            Tab(text: 'Detail'),
                            Tab(text: 'Pembayaran'),
                          ],
                        ),
                        SizedBox(height: 20),
                        Container(
                          height: 700, // Atur tinggi sesuai kebutuhan
                          child: TabBarView(
                            children: [
                              // Kodingan Tab Konten Status
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Status Pesanan",
                                      style: TextStyle(
                                        fontSize:
                                            getProportionateScreenWidth(16),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Column(
                                      children: List.generate(
                                        statusHistory.length,
                                        (index) => Card(
                                          color: getStatusColor(
                                              statusHistory[index]['status']),
                                          child: ListTile(
                                            leading: Icon(
                                              getStatusIcon(statusHistory[index]
                                                  ['status']),
                                              color: Colors.white,
                                            ),
                                            title: Text(
                                              statusHistory[index]['status'],
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            subtitle: statusHistory[index]
                                                        ['status'] ==
                                                    'Proses Desain'
                                                ? Text(
                                                    'Estimasi Pengerjaan: ${orderSnapshot!['estimasiPengerjaan']} Hari',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                : null,
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (orderSnapshot!['status'] == 'Ditolak')
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Column(
                                          children: [
                                            Text(
                                              'Pesanan Ditolak',
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        16),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              'Mohon maaf, pesanan Anda telah ditolak. Harap hubungi kami untuk informasi lebih lanjut.',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black45),
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (orderSnapshot!['statusPembayaran'] ==
                                        'Ditolak')
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Column(
                                          children: [
                                            Text(
                                              'Status Pembayaran Ditolak',
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        16),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              'Mohon maaf, status pembayaran Anda telah ditolak. Unggah kembali bukti pembayaran.',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black45),
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (orderSnapshot!['status'] == 'Selesai')
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                ElevatedButton(
                                                  onPressed:
                                                      _navigateToProductResult,
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Colors.lightBlue,
                                                    onPrimary: Colors.white,
                                                    elevation: 5,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10,
                                                            horizontal: 20),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                  ),
                                                  child: Text('Lihat Hasil'),
                                                ),
                                                ElevatedButton(
                                                  onPressed: _open2DPreview,
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Colors.lightBlue,
                                                    onPrimary: Colors.white,
                                                    elevation: 5,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10,
                                                            horizontal: 20),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                  ),
                                                  child: Text('Preview Hasil'),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              '*jika ingin melihat keseluruhan hasil desain, segera lakukan pelunasan pembayaran.',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black45),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),

                              // Tab Konten Detail
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Detail Produk",
                                      style: TextStyle(
                                        fontSize:
                                            getProportionateScreenWidth(16),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Card(
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "ID Pesanan: ${orderSnapshot!['orderId']}",
                                              style: TextStyle(
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        14),
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Divider(),
                                            SizedBox(height: 10),
                                            Text(
                                              "Panjang Ruangan: ${orderSnapshot!['panjangRuangan']} meter",
                                              style: TextStyle(
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        14),
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Divider(),
                                            SizedBox(height: 10),
                                            Text(
                                              "Lebar Ruangan: ${orderSnapshot!['lebarRuangan']} meter",
                                              style: TextStyle(
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        14),
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Divider(),
                                            SizedBox(height: 10),
                                            Text(
                                              "Tanggal Order: ${DateFormat('dd/MM/yyyy').format(orderSnapshot!['tanggalOrder'].toDate())}",
                                              style: TextStyle(
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        14),
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Tab Konten Pembayaran
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Metode Pembayaran :",
                                      style: TextStyle(
                                        fontSize:
                                            getProportionateScreenWidth(16),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Column(
                                      children: [
                                        PaymentMethodCard(
                                          icon: Image.asset(
                                            'assets/images/bni_logo.png',
                                            height: 36,
                                          ),
                                          title: 'Transfer Bank BNI',
                                          accountNumber: '1451040146',
                                        ),
                                        PaymentMethodCard(
                                          icon: Image.asset(
                                            'assets/images/dana_logo.png',
                                            height: 36,
                                          ),
                                          title: 'DANA',
                                          accountNumber: '082185752004',
                                        ),
                                        PaymentMethodCard(
                                          icon: Image.asset(
                                            'assets/images/gopay_logo.png',
                                            height: 36,
                                          ),
                                          title: 'GoPay',
                                          accountNumber: '082185752004',
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Divider(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Status Pembayaran : ",
                                          style: TextStyle(
                                            fontSize:
                                                getProportionateScreenWidth(16),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          (orderSnapshot!['statusPembayaran']),
                                          style: TextStyle(
                                            fontSize:
                                                getProportionateScreenWidth(14),
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(),
                                    Center(
                                      child: Text(
                                        "Unggah Bukti Pembayaran",
                                        style: TextStyle(
                                          fontSize:
                                              getProportionateScreenWidth(16),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    if (orderSnapshot!['statusPembayaran'] ==
                                        'Belum')
                                      Center(
                                        child: Text(
                                          "Nominal Uang Muka: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp.').format(orderSnapshot!['nominalUangMuka'])}",
                                          style: TextStyle(
                                            fontSize:
                                                getProportionateScreenWidth(14),
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    if (orderSnapshot!['statusPembayaran'] ==
                                        'Uang Muka')
                                      Center(
                                        child: Text(
                                          "Nominal Pelunasan: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp.').format(orderSnapshot!['nominalPelunasan'])}",
                                          style: TextStyle(
                                            fontSize:
                                                getProportionateScreenWidth(14),
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    SizedBox(height: 10),
                                    if (_paymentProofImage == null)
                                      ElevatedButton(
                                        onPressed: _pickPaymentProofImage,
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.orange,
                                          onPrimary: Colors.white,
                                          elevation: 5,
                                          padding: EdgeInsets.symmetric(
                                            vertical: 10,
                                            horizontal: 20,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.camera_alt,
                                              color: Colors.white,
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              'Pilih Foto Bukti Pembayaran',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    SizedBox(height: 10),
                                    if (_paymentProofImage != null)
                                      Column(
                                        children: [
                                          Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.file(
                                                  _paymentProofImage!,
                                                  height: 150,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Positioned(
                                                right: 10,
                                                bottom: 10,
                                                child: GestureDetector(
                                                  onTap:
                                                      _removePaymentProofImage,
                                                  child: Container(
                                                    padding: EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Icon(
                                                      Icons.close,
                                                      color: Colors.white,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          ElevatedButton(
                                            onPressed: _uploadPaymentProof,
                                            child:
                                                Text('Unggah Bukti Pembayaran'),
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.green,
                                              onPrimary: Colors.white,
                                              elevation: 5,
                                              padding: EdgeInsets.symmetric(
                                                vertical: 10,
                                                horizontal: 20,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class PaymentMethodCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final String accountNumber;

  const PaymentMethodCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.accountNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            icon,
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Nomor Rekening: $accountNumber',
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: accountNumber));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Nomor Rekening disalin')),
                );
              },
              icon: Icon(Icons.copy),
            ),
          ],
        ),
      ),
    );
  }
}
