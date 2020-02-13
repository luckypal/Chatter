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
import 'package:chatter/src/services/phone_contact.dart';
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
  PhoneContactService contactService;
  List<BaseContact> contacts;
  List<BaseContact> selectedContacts;
  String searchText = "";

  @override
  void initState() {
    super.initState();
    contactService = locator<PhoneContactService>();
    contacts = contactService.model;

    if (widget.selectedContacts != null)
      selectedContacts = widget.selectedContacts;
    else
      selectedContacts = new List<BaseContact>();
  }

  void onCreateGroup() {
    if (selectedContacts.length == 1) {
      Navigator.popAndPushNamed(context, "/Chat", arguments: {
        "name": null,
        "contacts": selectedContacts,
      });
    } else
      UI.showPrompt(
        context,
        label: "Group chat name",
        onResult: (bool result, String value) {
          Navigator.popAndPushNamed(context, "/Chat", arguments: {
            "name": value,
            "contacts": selectedContacts,
          });
        },
      );
  }

  void onChangedSearchText(String value) {
    setState(() {
      searchText = value;
      contacts = contactService.filterContacts(value);
    });
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
              child: SearchBarWidget(
                onChanged: onChangedSearchText,
              ),
            ),
            SizedBox(height: 5),
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
                      isSelected: isContactSelected(contacts[index]),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
