import 'package:flutter/material.dart';

class UI {
  static showSpinnerOverlay(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: null,
      transitionDuration: const Duration(milliseconds: 150),
      pageBuilder: (BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation) {
          return WillPopScope(
            onWillPop: () {},
            child: SafeArea(
              child: Builder(builder: (context) {
                return Material(
                    color: Colors.black45,
                    child: Align(
                        alignment: Alignment.center,
                        child: Container(
                            child: CircularProgressIndicator()
                          )
                        )
                      );
              })
            )
          );
      },
    );
  }
}