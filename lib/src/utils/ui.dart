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

  static void showAlert(
      BuildContext context,
      {String title = "Chatter",
      @required String content,
      Function onPressed}) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(content),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
                onPressed != null && onPressed();
              },
            ),
          ],
        );
      },
    );
  }
}