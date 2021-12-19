/*
    Created by Shitab Mir on 25 August 2021
    Updated by Shawon Lodh on 13 December 2021
 */

import 'package:logger/logger.dart';

enum LogType { verbose, debug, info, warning, error, terribleFailure }

class DebugUtil {
  static final instance = DebugUtil();
  static final logger = Logger(
    printer: PrettyPrinter(
      colors: true,
      methodCount: 0,
      printEmojis: true,
      printTime: true,
    ),
  );

  printLog({required Object? msg, LogType logType = LogType.debug}) {
    switch (logType) {
      case LogType.verbose:
        return logger.v(msg);
      case LogType.debug:
        return logger.d(msg);
      case LogType.info:
        return logger.i(msg);
      case LogType.warning:
        return logger.w(msg);
      case LogType.error:
        return logger.e(msg);
      case LogType.terribleFailure:
        return logger.wtf(msg);
    }
  }
}

