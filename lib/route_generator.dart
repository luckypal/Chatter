import 'package:flutter/material.dart';
import 'package:chatter/src/screens/init/splash.dart';
import 'package:chatter/src/screens/init/on_boarding.dart';
import 'package:chatter/src/screens/init/phone_input.dart';
import 'package:chatter/src/screens/init/phone_verify.dart';
import 'package:chatter/src/screens/init/profile_init.dart';
import 'package:chatter/src/screens/tabs/tabs.dart';
import 'package:chatter/src/screens/chat/contacts.dart';
import 'package:chatter/src/screens/chat/contacts_group.dart';
import 'package:chatter/src/screens/chat/chat.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashPage());
      case '/OnBoarding':
        return MaterialPageRoute(builder: (_) => OnBoardingPage());
      case '/PhoneInput':
        return MaterialPageRoute(builder: (_) => PhoneInputPage());
      case '/PhoneVerify':
        return MaterialPageRoute(builder: (_) => PhoneVerifyPage(args: args));
      case '/ProfileInit':
        return MaterialPageRoute(builder: (_) => ProfileInitPage());

      case '/Tabs':
        return MaterialPageRoute(
            builder: (_) => TabsWidget(currentTab: args != null ? args : 2));

      case '/Contacts':
        return MaterialPageRoute(builder: (_) => ContactsPage());
      case '/ContactsGroup':
        return MaterialPageRoute(builder: (_) => ContactsGroupPage());

      case '/Chat':
        Map<String, dynamic> chatArgs = args;
        return MaterialPageRoute(
            builder: (_) => ChatPage(
                  platform: chatArgs["platform"],
                  title: chatArgs["title"],
                  contacts: chatArgs["contacts"],
                ));
      case '/ChatWithModel':
        Map<String, dynamic> chatArgs = args;
        return MaterialPageRoute(
            builder: (_) => ChatPage.fromModel(chatArgs["model"]));
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
