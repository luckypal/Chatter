import 'package:get_it/get_it.dart';
import 'package:chatter/src/services/phone_verify.dart';
import 'package:chatter/src/services/user/owner.dart';
import 'package:chatter/src/services/user/chatter.dart';
import 'package:chatter/src/services/server.dart';

GetIt locator = GetIt.instance;

setupServiceLocator() {
  locator.registerLazySingleton<PhoneVerifyService>(() => PhoneVerifyServiceImpl());
  locator.registerLazySingleton<OwnerUserService>(() => OwnerUserServiceImpl());
  locator.registerLazySingleton<ChatterUserService>(() => ChatterUserServiceImpl());
  locator.registerLazySingleton<ServerService>(() => ServerServiceImpl());
}