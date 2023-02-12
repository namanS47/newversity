import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:newversity/utils/shimmer_effect_view.dart';

class FlutterDemoImageAsset extends StatelessWidget {
  final String? image;
  final double? height;
  final double? webHeight;
  final double? width;
  final double? webWidth;
  final Color? color;
  final BoxFit? fit;
  final BoxFit? webFit;

  const FlutterDemoImageAsset({
    Key? key,
    @required this.image,
    this.webFit,
    this.fit,
    this.height,
    this.webHeight,
    this.width,
    this.webWidth,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return image!.contains('http')
        ? CachedNetworkImage(
      imageUrl: '$image',
      height: webHeight,
      width: webWidth,
      fit: webFit ?? BoxFit.cover,
      placeholder: (context, url) => ShimmerEffectView(
          height: webHeight ?? double.maxFinite,
          width: webWidth ?? double.maxFinite),
      errorWidget: (context, url, error) =>
      const Icon(Icons.error, color: Colors.red),
    )
        : image!.contains('product/') || image!.contains('public/')
        ? CachedNetworkImage(
      imageUrl: 'https://d3df8f1z9cx8fl.cloudfront.net/$image',
      height: webHeight,
      width: webWidth,
      fit: webFit ?? BoxFit.cover,
      placeholder: (context, url) => ShimmerEffectView(
          height: webHeight ?? double.maxFinite,
          width: webWidth ?? double.maxFinite),
      errorWidget: (context, url, error) =>
      const Icon(Icons.error, color: Colors.red),
    )
        : image!.split('.').last != 'svg'
        ? Image.asset(
      image!,
      fit: fit,
      height: height,
      width: width,
      color: color,
    )
        : SvgPicture.asset(
      image!,
      height: height,
      width: width,
      color: color,
    );
  }
}
