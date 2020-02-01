import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/services.dart';
import 'package:chatter/config/app_config.dart' as config;
import 'package:chatter/src/utils/ui.dart';
import 'package:phone_number/phone_number.dart';

class PhoneVerifyPage extends StatefulWidget {
  @override
  _PhoneVerifyPageState createState() => _PhoneVerifyPageState();
}

class _PhoneVerifyPageState extends State<PhoneVerifyPage> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String phoneNumber = "+17865778328";
  PhoneNumber _phoneNumberPlugin = PhoneNumber();
  String verifyCode = "";

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    final formatted = await _phoneNumberPlugin.format(phoneNumber, "US");
    setState(() {
      phoneNumber = formatted ['formatted'];
    });
  }

  onVerifyCodeChanged(String str) {
    setState(() {
      verifyCode = str;
    });
  }

  void onVerifyCode() {

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
          'Verify your Phone number',
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
                'Did you receive SMS code? Input your verification code.',
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.body2,
              ),

              Container(
                alignment: Alignment.center,
                child:Text(
                  phoneNumber,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.display2,
                ),
              ),
              
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.10), offset: Offset(0, 4), blurRadius: 10)
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'Enter your verification code',
                      hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.8)),
                      border: UnderlineInputBorder(borderSide: BorderSide.none),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                    ),
                    style: Theme.of(context).textTheme.title,
                    onChanged: onVerifyCodeChanged,
                  ),
                )
              ),

              Container(
                alignment: Alignment.centerRight,
                child:FlatButton(
                  onPressed: verifyCode.isEmpty ? null : onVerifyCode,
                  child: Text(
                    'Verify',
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