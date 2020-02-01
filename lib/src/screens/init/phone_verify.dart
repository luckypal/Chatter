import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/services.dart';
import 'package:chatter/config/app_config.dart' as config;
import 'package:chatter/src/utils/ui.dart';
import 'package:flutter/services.dart';
import 'package:phone_number/phone_number.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';

class PhoneInputArguments {
  final String phoneNumber;
  final CountryCode countryCode;
  final String verificationId;

  PhoneInputArguments({
    @required this.phoneNumber,
    @required this.countryCode,
    @required this.verificationId});
}

class PhoneVerifyPage extends StatefulWidget {
  final PhoneInputArguments args;

  const PhoneVerifyPage({Key key, this.args}): super(key: key);

  @override
  _PhoneVerifyPageState createState() => _PhoneVerifyPageState();
}

class _PhoneVerifyPageState extends State<PhoneVerifyPage> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String phoneNumber = "";
  PhoneNumber _phoneNumberPlugin = PhoneNumber();
  AuthCredential _authCredential;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    final formatted = await _phoneNumberPlugin.format(widget.args.phoneNumber, widget.args.countryCode.code);
    setState(() {
      phoneNumber = formatted ['formatted'];
    });
  }

  void onVerifyCode(verifyCode) async {
    _authCredential = PhoneAuthProvider.getCredential(verificationId: widget.args.verificationId, smsCode: verifyCode);
    UI.showSpinnerOverlay(context);

    try {
      Navigator.pop(context);
      AuthResult user = await firebaseAuth.signInWithCredential(_authCredential);
    } on PlatformException catch (error) {
      Navigator.pop(context);
      error.message;
    }
  }

  void onResendCode() {}

  void onChangePhoneNumber() {
    Navigator.pop(context);
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
                'Did you receive SMS code? Enter your verification code.',
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.body1,
              ),

              Container(
                alignment: Alignment.center,
                child:Text(
                  phoneNumber,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.display2,
                ),
              ),
              
              PinEntryTextField(
                fields: 6,
                onSubmit: onVerifyCode, // end onSubmit
              ),
              SizedBox(height: 15),

              MaterialButton(
                onPressed: onResendCode,
                padding: EdgeInsets.all(0),
                minWidth: 0,
                child: Text(
                  'Resend Verification Code',
                  style: Theme.of(context).textTheme.body2,
                ),
              ),

              MaterialButton(
                onPressed: onChangePhoneNumber,
                padding: EdgeInsets.all(0),
                minWidth: 0,
                child: Text(
                  'Change Phone number',
                  style: Theme.of(context).textTheme.body2,
                ),
              )

              // Container(
              //   alignment: Alignment.center,
              //   child: FlatButton(
              //     onPressed: verifyCode.isEmpty ? () {} : onVerifyCode,
              //     child: Text(
              //       'Verify',
              //       style: Theme.of(context).textTheme.button,
              //     ),
              //     color: Theme.of(context).accentColor,
              //     shape: StadiumBorder(),
              //   ),
              // ),
            ]
          )
        ),
      )
    );
  }
}