import 'package:firebase_auth/firebase_auth.dart';

abstract class PhoneVerifyService {
  bool isDone = false;
  String _phoneNumber;

  void phoneVerify(String phoneNumber);
  
  Function onVerificationCompleted = (AuthCredential _) {};
  Function onVerificationFailed = (AuthException _) {};
  Function onCodeSent = (String _, String __, [int]) {};
  Function onCodeAutoRetrievalTimeout = (String _) {};

  void verificationCompleted(AuthCredential auth) {
    !isDone && onVerificationCompleted(auth);
  }

  void verificationFailed(AuthException exception) {
    !isDone && onVerificationFailed(exception);
  }

  void codeSent(String verificationId, [int forceResendingToken]) {
    !isDone && onCodeSent(_phoneNumber, verificationId, forceResendingToken);
  }

  void codeAutoRetrievalTimeout(String verificationId) {
    !isDone && onCodeAutoRetrievalTimeout(verificationId);
  }
}

class PhoneVerifyServiceImpl extends PhoneVerifyService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  void phoneVerify(String phoneNumber) {
    _phoneNumber = phoneNumber;

    firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: Duration(seconds: 60),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }
}