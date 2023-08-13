import 'package:flutter/material.dart';
import 'package:dio/dio.dart'; // Import the dio package
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:photo_view/photo_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:typed_data';

class FullScreenImage extends StatefulWidget {
  final String imageUrl;

  FullScreenImage({required this.imageUrl});

  @override
  _FullScreenImageState createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.download_rounded),
            onPressed: _downloadImage,
          ),
        ],
      ),
      body: Center(
        child: PhotoView(
          imageProvider: NetworkImage(widget.imageUrl),
        ),
      ),
    );
  }

  void _downloadImage() async {
    try {
      final response = await Dio().get(
        widget.imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 100,
      );

      if (result['isSuccess']) {
        Fluttertoast.showToast(msg: 'Gambar berhasil diunduh ke galeri');
      } else {
        Fluttertoast.showToast(msg: 'Gagal menyimpan gambar ke galeri');
      }
    } catch (error) {
      Fluttertoast.showToast(msg: 'Terjadi kesalahan saat mengunduh gambar');
    }
  }
}
