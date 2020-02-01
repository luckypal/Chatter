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
import 'package:chatter/src/services/phone_verify.dart';
import 'package:chatter/service_locator.dart';

class PhoneInputArguments {
  String phoneNumber;
  CountryCode countryCode;
  String verificationId;
  Function beforeBack;

  PhoneInputArguments({
    @required this.phoneNumber,
    @required this.countryCode,
    @required this.verificationId,
    @required this.beforeBack});
}

class PhoneVerifyPage extends StatefulWidget {
  final PhoneInputArguments args;

  const PhoneVerifyPage({Key key, this.args}): super(key: key);

  @override
  _PhoneVerifyPageState createState() => _PhoneVerifyPageState();
}

class _PhoneVerifyPageState extends State<PhoneVerifyPage> {
  PhoneVerifyService phoneVerifyService;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  String phoneNumber = "";

  PhoneNumber _phoneNumberPlugin = PhoneNumber();
  AuthCredential _authCredential;

  @override
  void initState() {
    super.initState();
    initPlatformState();

    phoneVerifyService = locator<PhoneVerifyService>();

    phoneVerifyService.onVerificationCompleted = (AuthCredential auth) {};

    phoneVerifyService.onVerificationFailed = (AuthException exception) {
    };

    //Resent
    phoneVerifyService.onCodeSent = (String phoneNumberWithCode, String verificationId, [int forceResendingToken]) {
      UI.closeSpinnerOverlay(context);
      widget.args.verificationId = verificationId;
      UI.showAlert(context, content: "Verification code is resent.");
    };

    phoneVerifyService.onCodeAutoRetrievalTimeout = (String verificationId) {
      //Resend verification Code again or pop
      UI.showConfirm(context, content: "Verification code is timeout.\nDo you wanna resend code again?", onResult: (bool result) {
        if (result) { //Yes
          UI.showSpinnerOverlay(context);
          phoneVerifyService.phoneVerify(widget.args.phoneNumber);
        } else {  //No
          widget.args.beforeBack();
          UI.closeSpinnerOverlay(context);
          Navigator.pop(context);
        }
      });
    };
  }

  Future<void> initPlatformState() async {
    final formatted = await _phoneNumberPlugin.format(widget.args.phoneNumber, widget.args.countryCode.code);
    setState(() {
      phoneNumber = formatted ['formatted'];
    });
  }

  void onVerifyCode(verifyCode) async {
    _authCredential = PhoneAuthProvider.getCredential(verificationId: widget.args.verificationId, smsCode: verifyCode);

    try {
      UI.showSpinnerOverlay(context);
      AuthResult user = await firebaseAuth.signInWithCredential(_authCredential);
      UI.closeSpinnerOverlay(context);
      phoneVerifyService.isDone = true;
      Navigator.pushNamedAndRemoveUntil(context, "/ProfileInit", ModalRoute.withName("/"));
    } on PlatformException catch (error) {
      // error.message;
      UI.closeSpinnerOverlay(context);
      UI.showAlert(context, content: error.message);
    }
  }

  void onResendCode() {
    UI.showSpinnerOverlay(context);
    phoneVerifyService.phoneVerify(widget.args.phoneNumber);
  }

  void onChangePhoneNumber() {
    widget.args.beforeBack();
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
            ]
          )
        ),
      )
    );
  }
}