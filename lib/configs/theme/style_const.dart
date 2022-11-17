import 'package:flutter/material.dart';
import 'package:nps_social/configs/theme/color_const.dart';
import 'package:nps_social/configs/theme/size_const.dart';

class StyleConst {
  static TextStyle boldStyle(
          {Color? color,
          double? fontSize,
          double? height,
          FontWeight? fontWeight,
          FontStyle? fontStyle,
          TextDecoration? textDecoration,
          String? package}) =>
      TextStyle(
          color: color ?? ColorConst.blue,
          package: package,
          height: height ?? 1.3,
          fontWeight: fontWeight ?? FontWeight.bold,
          fontStyle: fontStyle ?? FontStyle.normal,
          fontSize: fontSize ?? defaultSize,
          decoration: textDecoration ?? TextDecoration.none);
}
