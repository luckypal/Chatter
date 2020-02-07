import 'package:chatter/service_locator.dart';
import 'package:chatter/src/utils/ui.dart';
import 'package:chatter/src/widgets/DrawerWidget.dart';
import 'package:chatter/src/widgets/searchbarwidget.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chatter/config/app_config.dart' as config;
import 'package:chatter/src/services/contact.dart';

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
    new Future.delayed(const Duration(milliseconds: 100), initContact);
  }

  void initContact() async {
    ContactService contactService = locator<ContactService>();
    UI.showSpinnerOverlay(context);
    await contactService.load();
    UI.closeSpinnerOverlay(context);
    setState(() {
      this.contactService = contactService;
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
            contactService != null
                ? ListView.separated(
                    padding: EdgeInsets.only(top: 5),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 0);
                    },
                    itemCount: contactService.model.length,
                    itemBuilder: (context, index) => contactBuilder(
                        contact: contactService.model[index], onPressed: () {}),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget contactBuilder({Contact contact, Function onPressed}) {
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
            contact.avatar != null && contact.avatar.length > 0
                ? CircleAvatar(
                    backgroundImage: MemoryImage(contact.avatar),
                  )
                : CircleAvatar(
                    child: Text(
                      contact.initials(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
            SizedBox(width: 15),
            Expanded(
              child: Text(
                contact.displayName,
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
