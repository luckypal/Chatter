import 'dart:math';

import 'package:chatter/service_locator.dart';
import 'package:chatter/src/models/message/base.dart';
import 'package:chatter/src/services/user/owner.dart';
import 'package:chatter/src/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:chatter/config/app_config.dart' as config;

class MessageWidget extends StatefulWidget {
  final MessageModel model;
  final Animation animation;
  final OwnerUserService ownerUserService;

  bool randValue = Random().nextBool();
  bool get isSentMessage => model.senderId == ownerUserService.identifier;

  MessageStatus get messageStatus => MessageStatus.received;

  MessageWidget({Key key, this.model, this.animation})
      : ownerUserService = locator<OwnerUserService>(),
        super(key: key);

  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  @override
  Widget build(BuildContext context) {
    return getMessageLayout(context);

    return new SizeTransition(
      sizeFactor: new CurvedAnimation(
          parent: widget.animation, curve: Curves.decelerate),
      child: getMessageLayout(context),
    );
  }

  Color get messageBackgroundColor =>
      widget.isSentMessage ? Color(0xFFe4f9ff) : Colors.white; //0xFFdcf8c6
  Color get messageColor =>
      widget.isSentMessage ? Color(0xFF303030) : Colors.black;

  BorderRadius getBorderRadius() {
    double borderCircular = 15;

    return widget.isSentMessage
        ? BorderRadius.only(
            topLeft: Radius.circular(borderCircular),
            bottomLeft: Radius.circular(borderCircular),
            bottomRight: Radius.circular(borderCircular),
          )
        : BorderRadius.only(
            topRight: Radius.circular(borderCircular),
            bottomLeft: Radius.circular(borderCircular),
            bottomRight: Radius.circular(borderCircular));
  }

  Widget getMessageLayout(context) {
    return Align(
      alignment:
          widget.isSentMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: config.App(context).appWidth(90)),
        decoration: BoxDecoration(
          color: messageBackgroundColor,
          borderRadius: getBorderRadius(),
        ),
        padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            new Flexible(
              child: new Column(
                crossAxisAlignment: widget.isSentMessage
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text(
                      widget.model.message,
                      textAlign: TextAlign.left,
                      style: TextStyle(color: messageColor, fontSize: 13),
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          Utilities.formatTime(widget.model.sentTime),
                          style:
                              TextStyle(color: Theme.of(context).disabledColor),
                        ),
                        Visibility(
                          visible: widget.isSentMessage,
                          child: buildStatusIcon(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Icon getStatusIcon() {
    switch (widget.messageStatus) {
      case MessageStatus.waiting:
        return Icon(
          Icons.access_time,
          color: Theme.of(context).disabledColor,
          size: 15,
        );
      case MessageStatus.sent:
        return Icon(
          Icons.done,
          color: Theme.of(context).accentColor,
          size: 15,
        );
      case MessageStatus.received:
        return Icon(
          Icons.done_all,
          color: Theme.of(context).accentColor,
          size: 15,
        );
    }
    return null;
  }

  Widget buildStatusIcon() {
    return Padding(
      padding: EdgeInsets.only(left: 5),
      child: getStatusIcon(),
    );
  }
/*
  Widget getReceivedMessageLayout(context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15), bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
        padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                    margin: const EdgeInsets.only(right: 8.0),
                    child: new CircleAvatar(
                      backgroundImage: AssetImage(this.chat.user.avatar),
                    )),
              ],
            ),
            new Flexible(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(this.chat.user.name,
                      style: Theme.of(context).textTheme.body2.merge(TextStyle(color: Theme.of(context).primaryColor))),
                  new Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: new Text(
                      chat.text,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }*/
}
