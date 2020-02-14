import 'package:chatter/config/ui_icons.dart';
import 'package:chatter/src/models/conversation.dart/base.dart';
import 'package:chatter/src/models/user/base.dart';
import 'package:chatter/src/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';

class ConversationWidget extends StatefulWidget {
  final ConversationModel model;
  final ValueChanged<ConversationModel> onPressed;
  final ValueChanged<ConversationModel> onDismissed;

  ConversationWidget({Key key, this.model, this.onPressed, this.onDismissed}) : super(key: key);

  @override
  _ConversationWidgetState createState() => _ConversationWidgetState();
}

class _ConversationWidgetState extends State<ConversationWidget> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.model.hashCode.toString()),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Icon(
              UiIcons.trash,
              color: Colors.white,
            ),
          ),
        ),
      ),
      onDismissed: (direction) {
        // Remove the item from the data source.
        setState(() {
          widget.onDismissed(widget.model);
        });

        // Then show a snackbar.
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text("The conversation with ${widget.model.title} is dismissed")));
      },
      child: InkWell(
        onTap: () => widget.onPressed(widget.model),
        child: Container(
          color: widget.model.unreadMessageCount == 0 ? Colors.transparent : Theme.of(context).focusColor.withOpacity(0.15),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[CircleAvatar(
                    backgroundImage: Image.network(widget.model.photoUrl).image,
                  ),
                  Positioned(
                    bottom: 3,
                    right: 3,
                    width: 12,
                    height: 12,
                    child: Container(
                      decoration: BoxDecoration(
                        color: UIColors.userStatusColor(widget.model.userState),
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(width: 15),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      widget.model.title,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      style: Theme.of(context).textTheme.body2,
                    ),
                    Visibility(
                      visible: widget.model.hasLastMessage,
                      child: Text(
                        widget.model.lastMessage,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.caption.merge(
                            TextStyle(fontWeight: widget.model.unreadMessageCount == 0 ? FontWeight.w300 : FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                child: Badge(
                  badgeContent: Text(
                    widget.model.unreadMessageCount.toString(),
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: TextStyle(color: Colors.white),
                  ),
                  badgeColor: Theme.of(context).accentColor,
                ),
                visible: widget.model.hasUnreadMessage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
