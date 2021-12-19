/*
    Created by Shitab Mir on 12 August 2021
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LargeSquaredButton extends StatefulWidget {
  final Function()? function;
  final String? image;
  final String? title;

  /// Constructor
  LargeSquaredButton({
    required this.function,
    required this.title,
    this.image,
  });

  @override
  _LargeSquaredButtonState createState() => _LargeSquaredButtonState();
}

class _LargeSquaredButtonState extends State<LargeSquaredButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.function,
      child: Container(
        width: 120.w,
        height: 120.w,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          gradient: LinearGradient(
            colors: <Color>[
              Color(0xFF9EC7D5),
              Color(0xFF63B6EE),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10.w,left: 30.w,right: 30.w,bottom: 10.w),
              child: SvgPicture.asset(widget.image!,width: 60.w,height: 60.w,),
            ),
            Text(widget.title!,textAlign: TextAlign.center,style: TextStyle(color: Colors.white, fontSize: 14.sp,fontStyle: FontStyle.normal,fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}