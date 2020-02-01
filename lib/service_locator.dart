import 'package:get_it/get_it.dart';
import 'package:chatter/src/services/phone_verify.dart';

GetIt locator = GetIt.instance;

setupServiceLocator() {
  locator.registerLazySingleton<PhoneVerifyService>(() => PhoneVerifyServiceImpl());
}