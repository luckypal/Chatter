import 'package:chatter/src/screens/init/phone_verify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/services.dart';
import 'package:chatter/config/app_config.dart' as config;
import 'package:chatter/src/utils/ui.dart';
import 'package:chatter/src/services/phone_verify.dart';
import 'package:chatter/service_locator.dart';

class ProfileInitPage extends StatefulWidget {
  @override
  _ProfileInitPageState createState() => _ProfileInitPageState();
}

class _ProfileInitPageState extends State<ProfileInitPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.96),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Profile Init',
          style: Theme.of(context).textTheme.display3,
        ),
      ),
      body: 
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 15),
              Text(
                'Enter your profile data',
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.body2,
              ),

              Container(
                alignment: Alignment.centerRight,
                child:FlatButton(
                  onPressed: () {/*FirebaseAuth.instance.signOut();*/},
                  child: Text(
                    'Done',
                    style: Theme.of(context).textTheme.button,
                  ),
                  color: Theme.of(context).accentColor,
                  shape: StadiumBorder(),
                ),
              ),
            ]
          )
        ),
      )
    );
  }
}