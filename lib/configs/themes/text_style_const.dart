import 'package:flutter/material.dart';
import 'package:npssolutions_mobile/configs/themes/color_const.dart';

class TextStyleConst {
  static const String _fontMedium = "Roboto-Medium";
  static const String _fontBold = "Roboto-Bold";
  static const String _fontRegular = "Roboto-Regular";

  static const double _defaultSize = 16;

  static TextStyle regularStyle({
    Color? color,
    double? fontSize,
    double? height,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    TextDecoration? textDecoration,
    String? package,
  }) =>
      TextStyle(
        fontFamily: _fontMedium,
        color: color ?? ColorConst.textPrimary,
        fontSize: fontSize ?? _defaultSize,
        height: height ?? 1.1,
        fontWeight: fontWeight ?? FontWeight.w400,
        fontStyle: fontStyle ?? FontStyle.normal,
        decoration: textDecoration ?? TextDecoration.none,
        package: package,
      );

  static TextStyle mediumStyle({
    Color? color,
    double? fontSize,
    double? height,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    TextDecoration? textDecoration,
    String? package,
  }) =>
      TextStyle(
        fontFamily: _fontMedium,
        color: color ?? ColorConst.textPrimary,
        fontSize: fontSize ?? _defaultSize,
        height: height ?? 1.1,
        fontWeight: fontWeight ?? FontWeight.w500,
        fontStyle: fontStyle ?? FontStyle.normal,
        decoration: textDecoration ?? TextDecoration.none,
        package: package,
      );

  static TextStyle boldStyle({
    Color? color,
    double? fontSize,
    double? height,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    TextDecoration? textDecoration,
    String? package,
  }) =>
      TextStyle(
        fontFamily: _fontBold,
        color: color ?? ColorConst.textPrimary,
        fontSize: fontSize ?? _defaultSize,
        height: height ?? 1.3,
        fontWeight: fontWeight ?? FontWeight.bold,
        fontStyle: fontStyle ?? FontStyle.normal,
        decoration: textDecoration ?? TextDecoration.none,
        package: package,
      );

  static TextStyle semiBoldStyle({
    Color? color,
    double? fontSize,
    double? height,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    TextDecoration? textDecoration,
    String? package,
  }) =>
      TextStyle(
        fontFamily: _fontBold,
        color: color ?? ColorConst.textPrimary,
        fontSize: fontSize ?? _defaultSize,
        height: height ?? 1.3,
        fontWeight: fontWeight ?? FontWeight.w600,
        fontStyle: fontStyle ?? FontStyle.normal,
        decoration: textDecoration ?? TextDecoration.none,
        package: package,
      );
}
