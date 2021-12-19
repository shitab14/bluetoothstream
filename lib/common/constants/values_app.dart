/*
    Created by Shitab Mir on 5 September 2021
 */
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'colors_app.dart';

class AppValues {

  static AppValues instance = AppValues();

  var pagePadding = EdgeInsets.all(15.0);
  var cardPadding = EdgeInsets.all(10.0);
  var bigPadding = EdgeInsets.all(20.0);

  var boxShadowForCard = [ const BoxShadow(
    color: Colors.grey,
    blurRadius: 2.0,
    spreadRadius: 1.0,
    offset: Offset(0.0, 1.0), // shadow direction: bottom right
  )
  ];

  // Transparent Image
  Uint8List kTransparentImage = Uint8List.fromList(<int>[
    0x89,
    0x50,
    0x4E,
    0x47,
    0x0D,
    0x0A,
    0x1A,
    0x0A,
    0x00,
    0x00,
    0x00,
    0x0D,
    0x49,
    0x48,
    0x44,
    0x52,
    0x00,
    0x00,
    0x00,
    0x01,
    0x00,
    0x00,
    0x00,
    0x01,
    0x08,
    0x06,
    0x00,
    0x00,
    0x00,
    0x1F,
    0x15,
    0xC4,
    0x89,
    0x00,
    0x00,
    0x00,
    0x0A,
    0x49,
    0x44,
    0x41,
    0x54,
    0x78,
    0x9C,
    0x63,
    0x00,
    0x01,
    0x00,
    0x00,
    0x05,
    0x00,
    0x01,
    0x0D,
    0x0A,
    0x2D,
    0xB4,
    0x00,
    0x00,
    0x00,
    0x00,
    0x49,
    0x45,
    0x4E,
    0x44,
    0xAE,
  ]);

  // Decorations
  BoxDecoration capsuleDecoration = BoxDecoration(
    shape: BoxShape.rectangle,
    border: Border.all(color: AppColors.instance.statusBarColor),
    borderRadius: const BorderRadius.all(Radius.circular(45.0)),
    color: AppColors.instance.statusBarColor,
    boxShadow: [
      const BoxShadow(
        color: Colors.white,
        blurRadius: 0.0,
        spreadRadius: 0.0,
        offset: Offset(0.0, 0.0), // shadow direction: bottom right
      ),
    ],
  );

}