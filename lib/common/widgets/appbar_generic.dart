/*
    Created by Shitab Mir on 16 August 2021
 */
import 'package:flutter/material.dart';
import 'package:watermonitoringapp/common/constants/colors_app.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GenericAppBarView extends StatefulWidget implements PreferredSizeWidget {
  final Color background;
  final Color textAndIconColor;
  final String title;
  final double toolbarHeight;
  final String? textButton;
  final Color textButtonColor;
  final Function()? textButtonFunction;

  /// Constructor
  GenericAppBarView({
    required this.title,
    this.background = Colors.white,
    this.textAndIconColor = Colors.black,
    this.toolbarHeight = 60,
    this.textButton, // = null
    this.textButtonColor = Colors.transparent,
    this.textButtonFunction, // = null
  });

  @override
  _GenericAppBarViewState createState() => _GenericAppBarViewState();

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight.h);

}

class _GenericAppBarViewState extends State<GenericAppBarView> {

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      toolbarHeight: widget.toolbarHeight,
      title: FittedBox(
        fit: BoxFit.fitWidth,
        child: Text(
          widget.title,
          style: TextStyle(
            color: widget.textAndIconColor,
            fontSize: 16.sp,
          ),
        ),
      ),
      iconTheme: IconThemeData(
        color: widget.textAndIconColor,
      ),
      backgroundColor: widget.background,
      actions: [
        (widget.textButton == null) ? Container() : TextButton(
          onPressed: widget.textButtonFunction,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal:10,),
            child: Text(widget.textButton.toString(),style: TextStyle(color: AppColors.instance.lightBlueTextButtonColor),),
          ),
        ),
      ]
      ,
    );
  }

}