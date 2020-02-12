import 'dart:io' show Platform;
import 'package:chatter/config/text.dart';
import 'package:chatter/config/ui_icons.dart';
import 'package:chatter/service_locator.dart';
import 'package:chatter/src/models/contact.dart';
import 'package:chatter/src/utils/ui.dart';
import 'package:chatter/src/widgets/DrawerWidget.dart';
import 'package:chatter/src/widgets/searchbarwidget.dart';
import 'package:chatter/src/widgets/ContactWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chatter/config/app_config.dart' as config;
import 'package:chatter/src/services/contact.dart';
import 'package:share/share.dart';
// import 'package:intent/intent.dart' as AndroidIntent1;
import 'package:intent/action.dart' as AndroidIntentActions;
import 'package:android_intent/android_intent.dart';

class ContactsGroupPage extends StatefulWidget {
  final List<BaseContact> selectedContacts;

  ContactsGroupPage({this.selectedContacts});

  @override
  _ContactsGroupPageState createState() => _ContactsGroupPageState();
}

class _ContactsGroupPageState extends State<ContactsGroupPage> {
  // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ContactService contactService;
  List<BaseContact> selectedContacts;

  @override
  void initState() {
    super.initState();
    contactService = locator<ContactService>();

    if (widget.selectedContacts != null)
      selectedContacts = widget.selectedContacts;
    else
      selectedContacts = new List<BaseContact>();
  }

  void onCreateGroup() async {
    // Navigator.pushNamed(context, "/Chat", arguments: selectedContacts);
  }

  int getContactIndex(BaseContact contact) {
    return selectedContacts.indexOf(contact);
  }

  bool isContactSelected(BaseContact contact) {
    return getContactIndex(contact) != -1;
  }

  bool get isSelectedContact => selectedContacts.length != 0;

  void onContactPressed(BaseContact contact) {
    int index = getContactIndex(contact);
    List<BaseContact> temp = selectedContacts;
    if (index == -1)
      temp.add(contact);
    else
      temp.removeAt(index);

    setState(() {
      selectedContacts = temp;
    });
  }

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
          'New Group',
          style: Theme.of(context).textTheme.display1,
        ),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.check, color: Theme.of(context).hintColor),
            onPressed: isSelectedContact ? onCreateGroup : null,
            tooltip: "Create New Group",
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
            contactService.model != null
                ? ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 0);
                    },
                    itemCount: contactService.model.length,
                    itemBuilder: (context, index) => ContactWidget(
                      contact: contactService.model[index],
                      onPressed: () =>
                          onContactPressed(contactService.model[index]),
                      isSelected:
                          isContactSelected(contactService.model[index]),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}