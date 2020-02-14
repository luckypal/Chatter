import 'package:chatter/src/models/user/base.dart';

abstract class ConversationModel {
  String _identifier;
  String _title;
  List<String> _userIds;
  int _platform;
  int _createdTime;

  String photoUrl;
  List<UserModel> userModel;

  String get identifier => _identifier;
  set identifier(value) => _identifier = value;

  String get title => _title;
  set title(value) => _title = value;

  List<String> get userIds => _userIds;
  set userIds(value) => _userIds = value;

  int get platform => _platform;
  set platform(value) => _platform = value;

  int get createdTime => _createdTime;
  set createdTime(value) => _createdTime = value;

  int get unreadMessageCount => 0;
  bool get hasUnreadMessage => false;

  bool get hasLastMessage => true;
  String get lastMessage => "";

  UserState get userState => isSingleChat ? userModel [0].userState : UserState.unknown;

  bool get isSingleChat => (_userIds != null && _userIds.length == 2);

  bool get isGroupChat => (_userIds != null && _userIds.length != 2);

  ConversationModel();

  ConversationModel.create(
      String identifier, String title, List<String> userIds, int platform, int createdTime)
      : this._identifier = identifier,
        this._title = title,
        this._userIds = userIds,
        this._platform = platform,
        this._createdTime = createdTime;
  
  void save();
}
