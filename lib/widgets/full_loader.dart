import 'dart:ui';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

var toastCancelFunc;

void fullLoader(bool status, {bool loaderHasShown = false}) {
  if (status) {
    if (toastCancelFunc != null) {
      toastCancelFunc();
    }
    toastCancelFunc =
        BotToast.showCustomLoading(toastBuilder: (void Function() cancelFunc) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Center(
              child: Lottie.asset(
                'lib/assets/maya_loader.json',
                width: 130,
                height: 130,
              ),
            ),
          );
        });
  } else {
    if (toastCancelFunc != null) {
      toastCancelFunc();
      toastCancelFunc = null;
    }
  }
}
