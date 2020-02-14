import 'package:chatter/config/ui_icons.dart';
import 'package:chatter/service_locator.dart';
import 'package:chatter/src/services/user/owner.dart';
import 'package:chatter/src/utils/ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chatter/config/app_config.dart' as config;

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    new Future.delayed(const Duration(milliseconds: 100), initUser);
  }

  void initUser() async {
    UI.showSpinnerOverlay(context);
    
    OwnerUserService ownerUserService = locator<OwnerUserService>();
    FirebaseUser user = await ownerUserService.load();

    UI.closeSpinnerOverlay(context);

    if (user == null)
      Navigator.of(context).popAndPushNamed('/OnBoarding');
    else if (user.displayName == null || user.displayName.isEmpty) {
      Navigator.of(context).popAndPushNamed('/ProfileInit');
    } else
      Navigator.of(context).popAndPushNamed('/Tabs', arguments: 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.96),
      body: Container(
        width: config.App(context).appWidth(100),
        height: config.App(context).appHeight(100),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/splash.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
            child: Icon(UiIcons.chat,
                color: Colors.white, size: config.App(context).appWidth(25.0))),
      ),
    );
  }
}
