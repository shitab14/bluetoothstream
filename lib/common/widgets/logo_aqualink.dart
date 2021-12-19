/*
    Created by Shitab Mir on 12 August 2021
 */
import 'package:flutter/material.dart';
import 'package:watermonitoringapp/common/constants/image_app.dart';

class AqualinkLogoView extends StatelessWidget {
  final double scale;
  /// Constructor
  AqualinkLogoView({required this.scale});
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppImages.instance.aqualinkBanner,
      scale: scale,
    );
  }

}

