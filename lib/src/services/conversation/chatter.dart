import 'package:chatter/service_locator.dart';
import 'package:chatter/src/models/conversation.dart/chatter.dart';
import 'package:chatter/src/services/conversation/base.dart';
import 'package:chatter/src/services/user/owner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ChatterConversationService extends BaseConversationService {
  OwnerUserService ownerUserService;

  final Firestore firestore = Firestore.instance;
  List<ChatterConversationModel> get models => super.models;

  Stream<QuerySnapshot> queryStream;

  ChatterConversationService() {
    ownerUserService = locator<OwnerUserService>();
  }

  void load();
}

class ChatterConversationServiceImpl extends ChatterConversationService {
  @override
  void load() async {
    String identifier = ownerUserService.model.identifier;

    queryStream = firestore.collection('conversations/$identifier').snapshots();
    queryStream.listen((QuerySnapshot snapshot) {
      List<DocumentSnapshot> list = snapshot.documents;
      // list [0].
    });
  }
}
