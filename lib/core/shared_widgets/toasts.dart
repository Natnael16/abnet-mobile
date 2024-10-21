import 'package:fluttertoast/fluttertoast.dart';

import '../utils/colors.dart';

void errorSavingToast() => Fluttertoast.showToast(
    webShowClose: true,
    msg: "መመዝገብ አልተቻለም እባክዎ እንደገና ይሞክሩ",
    timeInSecForIosWeb: 10,
    webBgColor: AppColors.bgErrorColor);

void savedSuccessToast() => Fluttertoast.showToast(
    webShowClose: true, msg: "መረጃው በተሳካ ሁኔታ ተመዝግቧል", timeInSecForIosWeb: 10);
