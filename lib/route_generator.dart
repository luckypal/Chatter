import 'package:flutter/material.dart';
import 'package:chatter/src/screens/init/on_boarding.dart';
import 'package:chatter/src/screens/init/phone_input.dart';
import 'package:chatter/src/screens/init/phone_verify.dart';
import 'package:chatter/src/screens/init/profile_init.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => OnBoardingPage());
      case '/PhoneInput':
        return MaterialPageRoute(builder: (_) => PhoneInputPage());
      case '/PhoneVerify':
        return MaterialPageRoute(builder: (_) => PhoneVerifyPage(args: args));
      case '/ProfileInit':
        return MaterialPageRoute(builder: (_) => ProfileInitPage());
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
