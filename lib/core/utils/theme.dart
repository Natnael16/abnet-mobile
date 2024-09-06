import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'colors.dart';

const fontFamily = "Noto";
var appTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
    useMaterial3: true,
    cardColor: AppColors.defaultGrey,
    fontFamily: 'Noto',
    scaffoldBackgroundColor: AppColors.white,
    textTheme: TextTheme(
      labelMedium: TextStyle(
        fontFamily: fontFamily,
        color: AppColors.white,
        fontWeight: FontWeight.bold,
        fontSize: 16.sp,
      ),
      bodyLarge: TextStyle(
        fontFamily: fontFamily,
        color: AppColors.black,
        fontWeight: FontWeight.bold,
        fontSize: 16.sp,
      ),
      bodyMedium: TextStyle(
        fontFamily: fontFamily,
        color: AppColors.black,
        fontWeight: FontWeight.w500,
        fontSize: 16.sp,
      ),
      bodySmall: TextStyle(
        fontFamily: fontFamily,
        color: AppColors.black,
        fontSize: 15.sp,
      ),
      labelLarge: TextStyle(
        fontFamily: fontFamily,
        color: AppColors.black,
        fontWeight: FontWeight.w500,
        fontSize: 16.sp,
      ),
      labelSmall: TextStyle(
          fontFamily: "Poppins",
          fontSize: (15).sp,
          color: AppColors.defaultGrey,
          fontWeight: FontWeight.w500),
      displayLarge: TextStyle(
        fontFamily: "Poppins",
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
      ),
    ));
