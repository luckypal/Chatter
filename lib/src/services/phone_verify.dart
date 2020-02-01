import 'package:firebase_auth/firebase_auth.dart';

abstract class PhoneVerifyService {
  String _phoneNumber;

  void phoneVerify(String phoneNumber);
  
  Function onVerificationCompleted = (AuthCredential _) {};
  Function onVerificationFailed = (AuthException _) {};
  Function onCodeSent = (String _, String __, [int]) {};
  Function onCodeAutoRetrievalTimeout = (String _) {};

  void verificationCompleted(AuthCredential auth) {
    onVerificationCompleted(auth);
  }

  void verificationFailed(AuthException exception) {
    onVerificationFailed(exception);
  }

  void codeSent(String verificationId, [int forceResendingToken]) {
    onCodeSent(_phoneNumber, verificationId, forceResendingToken);
  }

  void codeAutoRetrievalTimeout(String verificationId) {
    onCodeAutoRetrievalTimeout(verificationId);
  }
}

class PhoneVerifyServiceImpl extends PhoneVerifyService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  void phoneVerify(String phoneNumber) {
    _phoneNumber = phoneNumber;

    firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: Duration(seconds: 5),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }
}