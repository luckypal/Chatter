import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/services.dart';
import 'package:chatter/config/app_config.dart' as config;
import 'package:chatter/src/utils/ui.dart';

class InputPhonePage extends StatefulWidget {
  @override
  _InputPhonePageState createState() => _InputPhonePageState();
}

class _InputPhonePageState extends State<InputPhonePage> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  CountryCode mCode;
  String strPhoneNumber = "7865778328";

  String actualCode;
  String status = "";

  @override
  void initState() {
    super.initState();
    mCode = new CountryCode(
      code: "US",
      dialCode: "+1"
    );
  }

  void onChangeCountry(CountryCode code) {
    setState(() {
      mCode = code;
    });
  }

  void onPhoneNumberChanged(number) {
    setState(() {
      strPhoneNumber = number;
    });
  }

  void onSendSMSCode() {
    String phoneNumber = mCode.dialCode + strPhoneNumber;

    final PhoneCodeSent codeSent = (String verificationId, [int forceResendingToken]) async {
      this.actualCode = verificationId;
      Navigator.pop(context);
      setState(() {
        print('Code sent to $phoneNumber');
        status = "\nEnter the code sent to " + phoneNumber;
      });
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      this.actualCode = verificationId;
      setState(() {
        status = "\nAuto retrieval time out";
      });
    };
    
    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      Navigator.pop(context);
      setState(() {
        status = '${authException.message}';

        print("Error message: " + status);
        if (authException.message.contains('not authorized'))
          status = 'Something has gone wrong, please try later';
        else if (authException.message.contains('Network'))
          status = 'Please check your internet connection and try again';
        else
          status = 'Something has gone wrong, please try later';
      });
    };
    final PhoneVerificationCompleted verificationCompleted = (AuthCredential auth) {
      Navigator.pop(context);
      setState(() {
        status = 'Auto retrieving verification code';
      });
    };

    firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: Duration(seconds: 60),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
      
    UI.showSpinnerOverlay(context);
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
          'Quick Start Setup',
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
                'Confirm your country and enter your phone number(s)',
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.body2,
              ),

              CountryCodePicker(
                onChanged: onChangeCountry,
                initialSelection: mCode.code,
                favorite: ["US"],
                showFlag: true,
                showOnlyCountryWhenClosed: true,
                alignLeft: true,
                textStyle: Theme.of(context).textTheme.title
              ),

              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.10), offset: Offset(0, 4), blurRadius: 10)
                  ],
                ),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        mCode.dialCode,
                        style: Theme.of(context).textTheme.title,
                      )
                    ),
                    Expanded(
                      flex: 1,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Enter your phone number',
                          hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.8)),
                          border: UnderlineInputBorder(borderSide: BorderSide.none),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                        ),
                        style: Theme.of(context).textTheme.title,
                        onChanged: onPhoneNumberChanged,
                      ),
                    ),
                  ]
                )
              ),

              Container(
                child: Text(
                  status
                ),
              ),

              Container(
                alignment: Alignment.centerRight,
                child:FlatButton(
                  onPressed: strPhoneNumber.isEmpty ? null : onSendSMSCode,
                  child: Text(
                    'Send SMS Code',
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