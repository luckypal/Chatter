import 'package:chatter/service_locator.dart';
import 'package:chatter/src/services/conversation/chatter.dart';
import 'package:chatter/src/services/conversation/multi.dart';
import 'package:chatter/src/services/user/multi.dart';
import 'package:flutter/material.dart';
import 'package:chatter/config/app_config.dart' as config;
import 'package:chatter/route_generator.dart';
import 'package:chatter/src/services/phone_verify.dart';
import 'package:chatter/src/services/user/owner.dart';
import 'package:chatter/src/services/user/chatter.dart';
import 'package:chatter/src/services/server.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  bool isCreatedService = false;

  ChatterConversationServiceImpl chatterConversationService;
  MultiConversationServiceImpl multiConversationService;

  MyApp() : super();

  setupServiceLocator() {
    if (isCreatedService) return;
    
    isCreatedService = true;
    locator.registerLazySingleton<PhoneVerifyService>(() => PhoneVerifyServiceImpl());
    locator.registerLazySingleton<OwnerUserService>(() => OwnerUserServiceImpl());
    locator.registerLazySingleton<ServerService>(() => ServerServiceImpl());

    locator.registerLazySingleton<ChatterUserService>(() => ChatterUserServiceImpl());
    locator.registerLazySingleton<MultiUserService>(() => MultiUserServiceImpl());
    
    chatterConversationService = ChatterConversationServiceImpl();
    locator.registerLazySingleton<ChatterConversationService>(() => chatterConversationService);
    
    multiConversationService = MultiConversationServiceImpl();
    locator.registerLazySingleton<MultiConversationService>(() => multiConversationService);

    chatterConversationService.init();
  }
  
  @override
  Widget build(BuildContext context) {
    setupServiceLocator();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => chatterConversationService),
        ChangeNotifierProvider(create: (context) => multiConversationService),
      ],
      child: MaterialApp(
        title: 'Chatter',
        initialRoute: "/",
        onGenerateRoute: RouteGenerator.generateRoute,
        debugShowCheckedModeBanner: false,
        darkTheme: ThemeData(
          fontFamily: 'Poppins',
          primaryColor: Color(0xFF252525),
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Color(0xFF2C2C2C),
          accentColor: config.Colors().mainDarkColor(1),
          hintColor: config.Colors().secondDarkColor(1),
          focusColor: config.Colors().accentDarkColor(1),
          textTheme: TextTheme(
            button: TextStyle(color: Color(0xFF252525)),
            headline: TextStyle(
                fontSize: 20.0, color: config.Colors().secondDarkColor(1)),
            display1: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                color: config.Colors().secondDarkColor(1)),
            display2: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
                color: config.Colors().secondDarkColor(1)),
            display3: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w700,
                color: config.Colors().mainDarkColor(1)),
            display4: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w300,
                color: config.Colors().secondDarkColor(1)),
            subhead: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: config.Colors().secondDarkColor(1)),
            title: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: config.Colors().mainDarkColor(1)),
            body1: TextStyle(
                fontSize: 12.0, color: config.Colors().secondDarkColor(1)),
            body2: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: config.Colors().secondDarkColor(1)),
            caption: TextStyle(
                fontSize: 12.0, color: config.Colors().secondDarkColor(0.7)),
          ),
        ),
        theme: ThemeData(
          fontFamily: 'Poppins',
          primaryColor: Colors.white,
          brightness: Brightness.light,
          accentColor: config.Colors().mainColor(1),
          focusColor: config.Colors().accentColor(1),
          hintColor: config.Colors().secondColor(1),
          textTheme: TextTheme(
            button: TextStyle(color: Colors.white),
            headline: TextStyle(
                fontSize: 20.0, color: config.Colors().secondColor(1)),
            display1: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                color: config.Colors().secondColor(1)),
            display2: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
                color: config.Colors().secondColor(1)),
            display3: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w700,
                color: config.Colors().mainColor(1)),
            display4: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w300,
                color: config.Colors().secondColor(1)),
            subhead: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: config.Colors().secondColor(1)),
            title: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: config.Colors().mainColor(1)),
            body1: TextStyle(
                fontSize: 12.0, color: config.Colors().secondColor(1)),
            body2: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: config.Colors().secondColor(1)),
            caption: TextStyle(
                fontSize: 12.0, color: config.Colors().secondColor(0.6)),
          ),
        ),
      ),
    );
  }
}
