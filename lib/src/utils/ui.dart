import 'package:flutter/material.dart';
import 'package:chatter/config/text.dart';

class UI {
  static bool isShowingSpinnerOverlay = false;

  static showSpinnerOverlay(BuildContext context) {
    isShowingSpinnerOverlay = true;

    showGeneralDialog<int>(
      context: context,
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: null,
      transitionDuration: const Duration(milliseconds: 150),
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return WillPopScope(
          onWillPop: () {},
          child: SafeArea(
            child: Builder(
              builder: (context) {
                return Material(
                    color: Colors.black45,
                    child: Align(
                        alignment: Alignment.center,
                        child: Container(child: CircularProgressIndicator())));
              },
            ),
          ),
        );
      },
    ).then((int _) {
      isShowingSpinnerOverlay = false;
    });
  }

  static void closeSpinnerOverlay(BuildContext context) {
    isShowingSpinnerOverlay && Navigator.pop(context);
  }

  static void showAlert(BuildContext context,
      {String title, @required String content, Function onPressed}) {
    if (title == null) title = UIText.appName;

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: new Text(title),
        content: new Text(content),
        actions: <Widget>[
          new FlatButton(
            child: new Text("Ok"),
            onPressed: () {
              Navigator.of(context).pop();
              onPressed != null && onPressed();
            },
          ),
        ],
      ),
    );
  }

  static void showConfirm(BuildContext context,
      {String title, @required String content, Function onResult}) {
    if (title == null) title = UIText.appName;

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: new Text(title),
        content: new Text(content),
        actions: <Widget>[
          new FlatButton(
            child: new Text("Yes"),
            onPressed: () {
              Navigator.of(context).pop();
              onResult(true);
            },
          ),
          new FlatButton(
            child: new Text("No"),
            onPressed: () {
              Navigator.of(context).pop();
              onResult(false);
            },
          ),
        ],
      ),
    );
  }

  static void showPrompt(BuildContext context,
      {@required String label, Function onResult}) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        String text = "";

        return AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: new Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                  autofocus: true,
                  decoration: new InputDecoration(
                    hintText: label,
                    hintStyle: TextStyle(color: Colors.black26),
                  ),
                  onChanged: (value) => text = value,
                ),
              )
            ],
          ),
          actions: <Widget>[
            new FlatButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                  onResult(false);
                }),
            new FlatButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.pop(context);
                  onResult(true, text);
                })
          ],
        );
      },
    );
  }
}
