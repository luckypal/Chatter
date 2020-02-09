import 'dart:io' show Platform;
import 'package:chatter/config/text.dart';
import 'package:chatter/config/ui_icons.dart';
import 'package:chatter/service_locator.dart';
import 'package:chatter/src/models/contact.dart';
import 'package:chatter/src/utils/ui.dart';
import 'package:chatter/src/widgets/DrawerWidget.dart';
import 'package:chatter/src/widgets/searchbarwidget.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chatter/config/app_config.dart' as config;
import 'package:chatter/src/services/contact.dart';
import 'package:share/share.dart';
import 'package:intent/intent.dart' as AndroidIntent;
import 'package:intent/action.dart' as AndroidIntentAction;
// import 'package:android_intent/android_intent.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ContactService contactService;

  @override
  void initState() {
    super.initState();
    contactService = locator<ContactService>();
    if (contactService.model == null)
      new Future.delayed(const Duration(milliseconds: 100), initContact);
  }

  void initContact() async {
    contactService = locator<ContactService>();
    UI.showSpinnerOverlay(context);
    await contactService.load();
    UI.closeSpinnerOverlay(context);
    setState(() {
      this.contactService = contactService;
    });
  }

  void onNewGroup() {}

  void onNewContact() async {
    if (Platform.isAndroid) {
      AndroidIntent.Intent()
        ..setAction(AndroidIntentAction.Action.ACTION_INSERT)
        ..setData(Uri.parse('content://contacts'))
        ..setType("vnd.android.cursor.dir/contact")
        ..startActivityForResult().then((List<String> value) {
          if (value.length != 0) initContact();
        });
    }
  }

  void onContactPressed(BaseContact contact) {
    Navigator.pushNamed(context, "/Chat", arguments: contact);
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
              child: SearchBarWidget(),
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
            contactService.model != null
                ? ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 0);
                    },
                    itemCount: contactService.model.length,
                    itemBuilder: (context, index) => contactBuilder(
                        contact: contactService.model[index], onPressed: () => onContactPressed(contactService.model[index])),
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

  Widget contactBuilder(
      {ChatterContact contact, Function onPressed, Function onLongPressed}) {
    return MaterialButton(
      onPressed: onPressed,
      onLongPress: onLongPressed,
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
                backgroundImage:
                    Image.network(contact.chatterModel.photoUrl).image),
            SizedBox(width: 15),
            Expanded(
              child: Text(
                contact.contact.displayName,
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
