import 'package:chatter/config/text.dart';
import 'package:chatter/src/utils/ui.dart';
import 'package:flutter/material.dart';
import 'package:chatter/config/app_config.dart' as config;
import 'package:chatter/config/ui_icons.dart';
import 'package:share/share.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatContactsWidget extends StatefulWidget {
  @override
  _ChatContactsWidgetState createState() => _ChatContactsWidgetState();
}

class _ChatContactsWidgetState extends State<ChatContactsWidget>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  onInviteFriend() {
    Share.share(UIText.invitationMsg, subject: 'Invite to ${UIText.appName}');
  }

  onAllowAccessToContacts() async {
    PermissionGroup permission = PermissionGroup.contacts;

    PermissionStatus status = await PermissionHandler().checkPermissionStatus(permission);
    if (status == PermissionStatus.granted) {
      UI.showAlert(context, content: "You are already allowed to access contacts.");
      return;
    }

    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler()
            .requestPermissions([permission]);
    if (permissions [permission] == PermissionStatus.granted) {
      UI.showAlert(context, content: "Allowed to access contacts.");
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

  @override
  Widget build(BuildContext context) {
    dynamic app = config.App(context);

    // double penIconSize = app.appWidth(15.0);

    return Container(
      width: app.appWidth(100.0),
      child: Column(
        children: <Widget>[
          Expanded(child: Container()),
          SizedBox(
            width: 70,
            height: 70,
            child: IconButton(
              icon: new Icon(Icons.edit,
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
                    text: "Allow Access to Contacts (Phone)",
                    onPressed: onAllowAccessToContacts);
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
}
