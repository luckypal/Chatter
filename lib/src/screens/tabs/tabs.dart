import 'dart:io';

import 'package:chatter/config/ui_icons.dart';
// import 'package:chatter/src/screens/account.dart';
// import 'package:chatter/src/screens/chat.dart';
// import 'package:chatter/src/screens/favorites.dart';
// import 'package:chatter/src/screens/home.dart';
// import 'package:chatter/src/screens/messages.dart';
// import 'package:chatter/src/screens/notifications.dart';
// import 'package:chatter/src/widgets/DrawerWidget.dart';
// import 'package:chatter/src/widgets/FilterWidget.dart';
// import 'package:chatter/src/widgets/ShoppingCartButtonWidget.dart';
import 'package:flutter/material.dart';
import 'package:chatter/src/screens/tabs/home.dart';

// ignore: must_be_immutable
class TabsWidget extends StatefulWidget {
  int currentTab = 2;
  int selectedTab = 2;
  String currentTitle = 'Home';
  Widget currentPage = HomeWidget();

  TabsWidget({
    Key key,
    this.currentTab,
  }) : super(key: key);

  @override
  _TabsWidgetState createState() {
    return _TabsWidgetState();
  }
}

class _TabsWidgetState extends State<TabsWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  initState() {
    _selectTab(widget.currentTab);
    super.initState();
  }

  @override
  void didUpdateWidget(TabsWidget oldWidget) {
    _selectTab(oldWidget.currentTab);
    super.didUpdateWidget(oldWidget);
  }

  void _selectTab(int tabItem) {
    setState(() {
      widget.currentTab = tabItem;
      widget.selectedTab = tabItem;
      switch (tabItem) {
        case 0:
          widget.currentTitle = 'Preferences';
          widget.currentPage = HomeWidget();
          break;
        case 1:
          widget.currentTitle = 'Calls';
          widget.currentPage = HomeWidget();
          break;
        case 2:
          widget.currentTitle = 'Contacts';
          widget.currentPage = HomeWidget();
          break;
        case 3:
          widget.currentTitle = 'Notifications';
          widget.currentPage = HomeWidget();
          break;
        case 4:
          widget.currentTitle = 'Emojis';
          widget.currentPage = HomeWidget();
          break;
        // case 5:
        //   widget.selectedTab = 3;
        //   widget.currentTitle = 'Chat';
        //   widget.currentPage = HomeWidget();
        //   break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        exit(0);
        return new Future(() => true);
      },
      child: Scaffold(
        key: _scaffoldKey,
        // drawer: DrawerWidget(),
        // endDrawer: FilterWidget(),
        appBar: AppBar(
          automaticallyImplyLeading: false,
  //        leading: new IconButton(
  //          icon: new Icon(UiIcons.return_icon, color: Theme.of(context).hintColor),
  //          onPressed: () => Navigator.of(context).pop(),
  //        ),
          leading: new IconButton(
            icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
            onPressed: () => _scaffoldKey.currentState.openDrawer(),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            widget.currentTitle,
            style: Theme.of(context).textTheme.display1,
          ),
          // actions: <Widget>[
          //   new ShoppingCartButtonWidget(
          //       iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),
          //   Container(
          //       width: 30,
          //       height: 30,
          //       margin: EdgeInsets.only(top: 12.5, bottom: 12.5, right: 20),
          //       child: InkWell(
          //         borderRadius: BorderRadius.circular(300),
          //         onTap: () {
          //           Navigator.of(context).pushNamed('/Tabs', arguments: 1);
          //         },
          //         child: CircleAvatar(
          //           backgroundImage: AssetImage('img/user2.jpg'),
          //         ),
          //       )),
          // ],
        ),
        body: widget.currentPage,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).accentColor,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          iconSize: 22,
          elevation: 0,
          backgroundColor: Colors.transparent,
          selectedIconTheme: IconThemeData(size: 25),
          unselectedItemColor: Theme.of(context).hintColor.withOpacity(1),
          currentIndex: widget.selectedTab,
          onTap: (int i) {
            this._selectTab(i);
          },
          // this will be set when a new tab is tapped
          items: [
            BottomNavigationBarItem(
              icon: Icon(UiIcons.settings),
              title: new Container(height: 0.0),
            ),
            BottomNavigationBarItem(
              icon: Icon(UiIcons.phone_call),
              title: new Container(height: 0.0),
            ),
            BottomNavigationBarItem(
                title: new Container(height: 5.0),
                icon: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Theme.of(context).accentColor.withOpacity(0.4), blurRadius: 40, offset: Offset(0, 15)),
                      BoxShadow(
                          color: Theme.of(context).accentColor.withOpacity(0.4), blurRadius: 13, offset: Offset(0, 3))
                    ],
                  ),
                  child: new Icon(UiIcons.chat, color: Theme.of(context).primaryColor),
                )),
            BottomNavigationBarItem(
              icon: new Icon(UiIcons.bell),
              title: new Container(height: 0.0),
            ),
            BottomNavigationBarItem(
              icon: new Icon(UiIcons.shopping_cart),
              title: new Container(height: 0.0),
            ),
          ],
        ),
      )
    );
  }
}
