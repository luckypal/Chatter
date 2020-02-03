import 'package:get_it/get_it.dart';
import 'package:chatter/src/services/phone_verify.dart';
import 'package:chatter/src/services/user.dart';
import 'package:chatter/src/services/server.dart';

GetIt locator = GetIt.instance;

setupServiceLocator() {
  locator.registerLazySingleton<PhoneVerifyService>(() => PhoneVerifyServiceImpl());
  locator.registerLazySingleton<UserService>(() => UserServiceImpl());
  locator.registerLazySingleton<ServerService>(() => ServerServiceImpl());
}