import 'dart:io' show Platform;
import 'package:chatter/config/text.dart';
import 'package:chatter/config/ui_icons.dart';
import 'package:chatter/service_locator.dart';
import 'package:chatter/src/models/user/base.dart';
import 'package:chatter/src/services/user/chatter.dart';
import 'package:chatter/src/utils/ui.dart';
import 'package:chatter/src/widgets/DrawerWidget.dart';
import 'package:chatter/src/widgets/searchbarwidget.dart';
import 'package:chatter/src/widgets/ContactWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chatter/config/app_config.dart' as config;
import 'package:share/share.dart';
// import 'package:intent/intent.dart' as AndroidIntent;
import 'package:intent/action.dart' as AndroidIntentActions;
import 'package:android_intent/android_intent.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ChatterUserService chatterUserService;
  List<UserModel> contacts;
  String searchText = "";

  @override
  void initState() {
    super.initState();
    chatterUserService = locator<ChatterUserService>();

    contacts = List<UserModel>();

    if (chatterUserService.models == null)
      new Future.delayed(const Duration(milliseconds: 100), initContact);
    else
      contacts.addAll(chatterUserService.models);
  }

  void initContact() async {
    chatterUserService = locator<ChatterUserService>();
    UI.showSpinnerOverlay(context);
    await chatterUserService.load();
    UI.closeSpinnerOverlay(context);
    setState(() {
      this.chatterUserService = chatterUserService;
      contacts.addAll(chatterUserService.models);
    });
  }

  void onChangedSearchText(String value) {
    setState(() {
      searchText = value;
      contacts = chatterUserService.findContacts(value);
    });
  }

  void onNewGroup() {
    Navigator.popAndPushNamed(context, "/ContactsGroup");
  }

  void onNewContact() async {
    if (Platform.isAndroid) {
      AndroidIntent intent = AndroidIntent(
        action: AndroidIntentActions.Action.ACTION_INSERT,
        data: 'content://contacts',
        type: "vnd.android.cursor.dir/contact",
      );
      await intent.launch();
    }
  }

  void onContactPressed(UserModel contact) {
    List<UserModel> contacts = new List<UserModel>();
    contacts.add(contact);
    Navigator.popAndPushNamed(context, "/Chat", arguments: {
      "name": null,
      "contacts": contacts,
    });
  }

  void onInviteFriend() {
    Share.share(UIText.invitationMsg, subject: 'Invite to ${UIText.appName}');
  }

  void onContactsHelp() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: _scaffoldKey,
      drawer: DrawerWidget(),
      appBar: AppBar(
        // automaticallyImplyLeading: false,
//        leading: new IconButton(
//          icon: new Icon(UiIcons.return_icon, color: Theme.of(context).hintColor),
//          onPressed: () => Navigator.of(context).pop(),
//        ),
        leading: new IconButton(
          icon:
              new Icon(Icons.chevron_left, color: Theme.of(context).hintColor),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Contacts',
          style: Theme.of(context).textTheme.display1,
        ),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.refresh, color: Theme.of(context).hintColor),
            onPressed: () => initContact(),
            tooltip: "Refresh Contacts",
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SearchBarWidget(
                onChanged: onChangedSearchText,
              ),
            ),
            SizedBox(height: 5),
            functionBuilder(
                icon: Icons.group_add,
                title: "New Group",
                onPressed: onNewGroup,
                color: Theme.of(context).accentColor),
            functionBuilder(
                icon: Icons.person_add,
                title: "New Contact",
                onPressed: onNewContact,
                color: Theme.of(context).accentColor),
            contacts != null
                ? ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 0);
                    },
                    itemCount: contacts.length,
                    itemBuilder: (context, index) => ContactWidget(
                      contact: contacts[index],
                      onPressed: () => onContactPressed(contacts[index]),
                    ),
                  )
                : SizedBox(),
            functionBuilder(
                icon: Icons.share,
                title: "Invite friend",
                onPressed: onInviteFriend),
            functionBuilder(
                icon: Icons.help,
                title: "Contacts help",
                onPressed: onContactsHelp),
          ],
        ),
      ),
    );
  }

  Widget functionBuilder(
      {IconData icon,
      String title,
      Function onPressed,
      Color color = Colors.transparent}) {
    return MaterialButton(
      onPressed: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
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
            CircleAvatar(
              backgroundColor: color,
              child: new Icon(icon,
                  color: color == Colors.transparent
                      ? Theme.of(context).hintColor
                      : Colors.white),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
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
}
