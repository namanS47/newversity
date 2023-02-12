import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

import 'new_versity_color_constant.dart';

class ShimmerEffectView extends StatelessWidget {
  final double? height;
  final double? width;
  final double? borderRadius;

  const ShimmerEffectView(
      {Key? key, this.height, this.width, this.borderRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: FlutterDemoColorConstant.wishListProduct,
      highlightColor: FlutterDemoColorConstant.itemBgColor,
      child: Container(
        height: height ?? 30.px,
        width: width ?? 50.px,
        decoration: BoxDecoration(
          color: FlutterDemoColorConstant.wishListProduct,
          borderRadius: BorderRadius.circular(borderRadius ?? 4.px),
        ),
      ),
    );
  }
}
