import 'package:chatter/config/text.dart';
import 'package:chatter/src/utils/ui.dart';
import 'package:flutter/material.dart';
import 'package:chatter/config/app_config.dart' as config;
import 'package:chatter/config/ui_icons.dart';
import 'package:chatter/src/widgets/searchbarwidget.dart';
import 'package:share/share.dart';
import 'package:permission_handler/permission_handler.dart';

class ConversationsWidget extends StatefulWidget {
  @override
  _ConversationsWidgetState createState() => _ConversationsWidgetState();
}

class _ConversationsWidgetState extends State<ConversationsWidget>
    with SingleTickerProviderStateMixin {
  bool isAccessContacts = false;

  bool isHasContacts = true;

  @override
  void initState() {
    super.initState();

    checkPermission();
  }

  void checkPermission() async {
    PermissionStatus status = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.contacts);
    if (status == PermissionStatus.granted) {
      setState(() {
        isAccessContacts = true;
      });
    }
  }

  onInviteFriend() {
    Share.share(UIText.invitationMsg, subject: 'Invite to ${UIText.appName}');
  }

  onAllowAccessToContacts() async {
    PermissionGroup permission = PermissionGroup.contacts;

    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([permission]);
    if (permissions[permission] == PermissionStatus.granted) {
      UI.showAlert(context, content: "Allowed to access contacts.");
      setState(() {
        isAccessContacts = true;
      });
    }
  }

  Widget createActionButton({IconData icon, String text, Function onPressed}) {
    return MaterialButton(
      onPressed: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          // color: Theme.of(context).primaryColor.withOpacity(0.9),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).focusColor.withOpacity(0.1),
                blurRadius: 5,
                offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            IconButton(
              icon: new Icon(icon, color: Theme.of(context).accentColor),
              onPressed: onPressed,
            ),
            SizedBox(width: 15),
            Expanded(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: Theme.of(context).textTheme.subhead,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget blankContacts() {
    return Container(
      width: config.App(context).appWidth(100.0),
      child: Column(
        children: <Widget>[
          Expanded(child: Container()),
          SizedBox(
            width: 80,
            height: 80,
            child: IconButton(
              icon: new Icon(Icons.message,
                  color: Theme.of(context).accentColor, size: 50),
              onPressed: () => {},
            ),
          ),
          SizedBox(height: 5),
          Text(
            "Tap to start messaging or new chat",
            style: Theme.of(context).textTheme.body2,
          ),
          SizedBox(height: 15),
          Text(
            "You can chat with anyone in \nyour phone contacts or social media \nfriends or follower lists.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.body1,
          ),
          Expanded(child: Container()),
          ListView.separated(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            primary: false,
            itemCount: 2,
            separatorBuilder: (context, index) {
              return SizedBox(height: 10);
            },
            itemBuilder: (context, index) {
              if (index == 0)
                return createActionButton(
                    icon: Icons.add,
                    text: "Invite a Friend to Chatter",
                    onPressed: onInviteFriend);
              else
                return createActionButton(
                    icon: UiIcons.users,
                    text: isAccessContacts
                        ? "Got Access to Contacts"
                        : "Allow Access to Contacts (Phone)",
                    onPressed:
                        isAccessContacts ? null : onAllowAccessToContacts);
            },
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Social Media Friends and Followers can\nbe invited when you set your preferences\nand allow ${UIText.appName} to Access your accounts.   ',
                  style: Theme.of(context).textTheme.body1,
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 5),
                Text(
                  'This is for your convenience only.\nYour contacts will not be solicited by ${UIText.appName}.',
                  style: Theme.of(context).textTheme.body1,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }

  Widget contactsList() {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 7),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SearchBarWidget(),
              ),
              /*Offstage(
                offstage: _conversationList.conversations.isEmpty,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shrinkWrap: true,
                  primary: false,
                  itemCount: _conversationList.conversations.length,
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 7);
                  },
                  itemBuilder: (context, index) {
                    return MessageItemWidget(
                      message: _conversationList.conversations.elementAt(index),
                      onDismissed: (conversation) {
                        setState(() {
                          _conversationList.conversations.removeAt(index);
                        });
                      },
                    );
                  },
                ),
              ),
              Offstage(
                offstage: _conversationList.conversations.isNotEmpty,
                child: EmptyMessagesWidget(),
              )*/
            ],
          ),
        ),
        Container(
          width: config.App(context).appWidth(100.0),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // double penIconSize = app.appWidth(15.0);

    return isHasContacts ? contactsList() : blankContacts();
  }
}