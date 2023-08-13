import 'package:flutter/material.dart';
import '../../../models/Result.dart';
import '../../../size_config.dart';

import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../widgets/fullscreen_image.dart';

class ProductImages extends StatefulWidget {
  const ProductImages({
    Key? key,
    required this.result,
  }) : super(key: key);

  final Result result;

  @override
  _ProductImagesState createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
  void _showFullScreenImage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImage(imageUrl: widget.result.image),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _showFullScreenImage(context),
          child: SizedBox(
            width: getProportionateScreenWidth(238),
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.network(
                widget.result.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Divider()
      ],
    );
  }
}
