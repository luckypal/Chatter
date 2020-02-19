
import 'package:chatter/service_locator.dart';
import 'package:chatter/src/models/user/base.dart';
import 'package:chatter/src/services/user/base.dart';
import 'package:chatter/src/services/user/chatter.dart';
import 'package:chatter/src/services/user/owner.dart';

abstract class MultiUserService extends BaseUserService {
  OwnerUserService ownerUserService;
  ChatterUserService chatterUserService;

  MultiUserService() {
    ownerUserService = locator<OwnerUserService>();
    chatterUserService = locator<ChatterUserService>();
  }
}

class MultiUserServiceImpl extends MultiUserService {
  
  @override
  Future<List<UserModel>> load() async {
    List<UserModel> chatterUserModel = await chatterUserService.load();

    if (models == null) models = new List<UserModel>();
    else models.clear();
    
    models.addAll(chatterUserModel);

    return models;
  }


  @override
  List<UserModel> findContacts(String searchText) {
    return chatterUserService.findContacts(searchText);
  }

  @override
  Future<List<UserModel>> findUsersByIds({List<String> contactIds}) {
    return chatterUserService.findUsersByIds(contactIds: contactIds);
  }

  @override
  Future<List<UserModel>> findUsersByPhoneNumber({List<String> phoneNumbers}) {
    return chatterUserService.findUsersByPhoneNumber(phoneNumbers: phoneNumbers);
  }
}