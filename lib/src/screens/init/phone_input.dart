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

class PhoneInputPage extends StatefulWidget {
  @override
  _PhoneInputPageState createState() => _PhoneInputPageState();
}

class _PhoneInputPageState extends State<PhoneInputPage> {
  PhoneVerifyService phoneVerifyService;
  CountryCode mCode;
  String strPhoneNumber = "";

  String verificationId;
  String status = "";

  @override
  void initState() {
    super.initState();
    mCode = new CountryCode(
      code: "US",
      dialCode: "+1"
    );

    phoneVerifyService = locator<PhoneVerifyService>();
    setServiceFunction();
  }

  void setServiceFunction() {
    phoneVerifyService.isDone = true;
    phoneVerifyService.onVerificationFailed = (AuthException exception) {
      UI.closeSpinnerOverlay(context);
      UI.showAlert(context, content: exception.message);
    };

    phoneVerifyService.onCodeSent = (String phoneNumberWithCode, String verificationId, [int forceResendingToken]) async {
      UI.closeSpinnerOverlay(context);

      this.verificationId = verificationId;
      Navigator.pushNamed(context, "/PhoneVerify", arguments: new PhoneInputArguments(
        verificationId: verificationId,
        countryCode: mCode,
        phoneNumber: phoneNumberWithCode,
        beforeBack: setServiceFunction
      ));
    };
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

    UI.showSpinnerOverlay(context);
    phoneVerifyService.phoneVerify(phoneNumber);
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