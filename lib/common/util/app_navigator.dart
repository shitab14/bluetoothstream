/*
    Created by Shitab Mir on 5 September 2021
 */
import 'package:flutter/material.dart';

class AppNavigator {

    static Future<void> goToNextScreen(BuildContext context, Widget nextScreen, Function? callOnReturn) async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => nextScreen));
    if(callOnReturn != null) callOnReturn();
  }

  static Future<void> goToNextScreenDestroyingPrevious(BuildContext context, Widget nextScreen) async {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => nextScreen));
  }

  static Future<void> goToNextScreenDestroyingPreviousAll(BuildContext context, Widget parentScreen) async {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => parentScreen),
            (Route<dynamic> route) => false
    );
  }

  static Future<Object?> goToNextScreenAndReturnWithData(BuildContext context, Widget nextScreen) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    );
    /// add following line to the next screen to exit and return with data.
    /*
      Navigator.pop(context, 'Your Desired Object');
    */
    return result;
  }

  static Future<void> goToNextScreenWithData(BuildContext context, Widget nextScreen, Object? args) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => nextScreen,
        settings: RouteSettings(
          arguments: args,
        ),
      ),
    );
  }

  /// Sample
  static Future<Object?> goToNextScreenWithDataAndReturn({required BuildContext context, required Widget nextScreen, Object? args}) async {
    final result = Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => nextScreen,
        settings: RouteSettings(
          arguments: args,
        ),
      ),
    );
    return result;
  }

}

