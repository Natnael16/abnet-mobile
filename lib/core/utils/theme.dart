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
var darkTheme = ThemeData(
  primaryColor: AppColors.primaryColor,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primaryColor,
    brightness: Brightness.dark, // Set brightness to dark
  ),
  useMaterial3: true,
  cardColor: Colors.grey[900], // Darker background for cards
  fontFamily: 'Noto',
  scaffoldBackgroundColor: Colors.black, // Dark background for scaffold
  textTheme: TextTheme(
    labelMedium: TextStyle(
      fontFamily: fontFamily,
      color: AppColors.white, // White text for contrast
      fontWeight: FontWeight.bold,
      fontSize: 16.sp,
    ),
    bodyLarge: TextStyle(
      fontFamily: fontFamily,
      color: AppColors.white, // White text for dark mode
      fontWeight: FontWeight.bold,
      fontSize: 16.sp,
    ),
    bodyMedium: TextStyle(
      fontFamily: fontFamily,
      color: AppColors.white, // White text for better contrast
      fontWeight: FontWeight.w500,
      fontSize: 16.sp,
    ),
    bodySmall: TextStyle(
      fontFamily: fontFamily,
      color: Colors.grey[300], // Slightly lighter grey for small text
      fontSize: 15.sp,
    ),
    labelLarge: TextStyle(
      fontFamily: fontFamily,
      color: Colors.white, // White text for labels
      fontWeight: FontWeight.w500,
      fontSize: 16.sp,
    ),
    labelSmall: TextStyle(
      fontFamily: "Poppins",
      fontSize: 15.sp,
      color: Colors.grey[500], // Light grey for smaller labels
      fontWeight: FontWeight.w500,
    ),
    displayLarge: TextStyle(
      fontFamily: "Poppins",
      fontSize: 24.sp,
      fontWeight: FontWeight.w600,
      color: Colors.white, // Large display text in white
    ),
  ),
);
