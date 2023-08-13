import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yusperabot/models/Result.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class ProductDescription extends StatelessWidget {
  const ProductDescription({
    Key? key,
    required this.result,
    this.pressOnSeeMore,
  }) : super(key: key);

  final Result result;
  final GestureTapCallback? pressOnSeeMore;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Text(
            result.title,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
            vertical: 10,
          ),
          child: GestureDetector(
            onTap: _openGoogleDriveLink,
            child: Row(
              children: [
                Text(
                  "Lihat Koleksi Gambar",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: kPrimaryColor,
                  ),
                ),
                SizedBox(width: 5),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: kPrimaryColor,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ID Pesanan : " + result.title,
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(14),
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Divider(),
                      Text(
                        "Panjang Ruangan : " + result.panjangRuangan + " meter",
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(14),
                          color: Colors.black,
                        ),
                      ),
                      Divider(),
                      Text(
                        "Lebar Ruangan: " + result.lebarRuangan + " meter",
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(14),
                          color: Colors.black,
                        ),
                      ),
                      Divider(),
                      Text(
                        "Tanggal Order : ${DateFormat('dd/MM/yyyy').format(result.tanggalOrder.toDate())} ",
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(14),
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
      ],
    );
  }

  void _openGoogleDriveLink() async {
    // const googleDriveLink =
    //     "https://drive.google.com/drive/folders/1fjRI7yTkU17udDZBhWso5sQBxpdJUUW0?usp=sharing"; // Ganti dengan link Google Drive Anda
    var googleDriveLink =
        result.linkDrive; // Ganti dengan link Google Drive Anda
    if (await canLaunch(googleDriveLink)) {
      await launch(googleDriveLink);
    } else {
      throw 'Tidak dapat membuka $googleDriveLink';
    }
  }
}
