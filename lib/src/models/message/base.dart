class MessageType {
  static const int TEXT = 0;
}

enum MessageStatus {
  waiting,
  sent,
  received
}

abstract class MessageModel {
  String _id;
  String _conversationId;
  String _senderId;
  int _platform;
  String _message;
  int _messageType;
  int _sentTime;

  String get identifier => _id;
  
  String get conversationId => _conversationId;
  set conversationId(value) => _conversationId = value;

  String get senderId => _senderId;
  int get platform => _platform;
  String get message => _message;
  int get messageType => _messageType;
  int get sentTime => _sentTime;

  MessageModel();

  MessageModel.create(String id, String conversationId, String senderId, int platform, String message, int messageType, int sentTime):
    _id = id,
    _conversationId = conversationId,
    _senderId = senderId,
    _platform = platform,
    _message = message,
    _messageType = messageType,
    _sentTime = sentTime {
      if (_sentTime == 0)
        _sentTime = DateTime.now().millisecondsSinceEpoch;
    }

  Future<String> save();
}
