import 'package:flutter/material.dart';

class AppColors {
  static const white = Color(0xffFFFFFF);
  static const darkGrey = Color(0xff342F3F);
  static const darkBlue = Color(0xff07183A);
  static const blue = Color(0xff0F6CBB);
  static const blueSecondary = Color(0xffA0D3FF);
  static const orange = Color(0xffF37908);
  static const orangeSecondary = Color(0xffFFC692);
  static const red = Color(0xff9E2A00);
  static const redSecondary = Color(0xffCB7F64);
  static const grey = Color(0xff7A869D);
  static const greySecondary = Color(0xffC8C8C8);
  static const green = Color(0xFF02912B);

  static const boxShadow = Color.fromRGBO(0, 0, 0, 0.25);
  static const border = Color.fromRGBO(245, 245, 245, 0.25);
  static const baseLoading = Color.fromARGB(255, 174, 174, 174);
  static const highlightLoading = Color.fromARGB(255, 255, 255, 255);

  static const LinearGradient scaffoldBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.blueSecondary,
      AppColors.greySecondary,
      AppColors.greySecondary,
      AppColors.blueSecondary,
    ],
    stops: [0.0, 0.15, 0.80, 1.0],
  );

  static const LinearGradient navbarBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.blueSecondary, AppColors.white],
    stops: [0.0, 0.55],
  );

  static const LinearGradient gradientModal = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.blueSecondary, AppColors.greySecondary],
    stops: [0.0, 1.0],
  );
}
