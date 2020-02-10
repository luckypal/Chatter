import 'dart:async';

import 'package:chatter/config/ui_icons.dart';
import 'package:chatter/src/models/contact.dart';
// import 'package:chatter/src/models/chat.dart';
// import 'package:chatter/src/models/conversation.dart';
import 'package:chatter/src/models/user.dart';
// import 'package:chatter/src/widgets/ChatMessageListItemWidget.dart';
import 'package:flutter/material.dart';

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: '', icon: Icons.videocam),
  const Choice(title: '', icon: Icons.phone),
  const Choice(title: 'View Contact', icon: Icons.contacts),
  const Choice(title: 'Media, links, and docs', icon: Icons.perm_media),
  const Choice(title: 'Search', icon: Icons.search),
  const Choice(title: 'Mute notifications', icon: Icons.notifications_off),
  const Choice(title: 'Wallpaper', icon: Icons.wallpaper),
  const Choice(title: 'More', icon: Icons.more_horiz),
];

class ChatPage extends StatefulWidget {
  final BaseContact contact;
  const ChatPage({Key key, this.contact}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // ConversationsList _conversationList = new ConversationsList();
  // User _currentUser = new User.init().getCurrentUser();
  final _myListKey = GlobalKey<AnimatedListState>();
  final myController = TextEditingController();
  final focusNode = new FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Row(
          children: [
            CircleAvatar(
                backgroundImage:
                    Image.network(widget.contact.userModel.photoUrl).image),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.contact.userModel.userName,
                  style: Theme.of(context).textTheme.display1,
                ),
                Text("Last seen at yesterday.",
                    style: Theme.of(context).textTheme.body1),
              ],
            ),
          ],
        ),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(choices[0].icon, color: Theme.of(context).hintColor),
            onPressed: () => _select(choices[0]),
          ),
          new IconButton(
            icon: new Icon(Icons.phone, color: Theme.of(context).hintColor),
            onPressed: () => _select(choices[1]),
          ),
          PopupMenuButton<Choice>(
            onSelected: _select,
            icon: Icon(Icons.more_vert, color: Theme.of(context).hintColor),
            itemBuilder: (BuildContext context) {
              return choices.skip(2).map((Choice choice) {
                return PopupMenuItem<Choice>(
                  value: choice,
                  child: Row(
                    children: [
                      Icon(choice.icon, color: Theme.of(context).hintColor),
                      SizedBox(width: 5),
                      Text(
                        choice.title,
                        style: TextStyle(color: Theme.of(context).hintColor),
                      ),
                    ],
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/chatbackground.png"),
              fit: BoxFit.cover),
          color: Theme.of(context).hintColor.withOpacity(0.10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
                child:
                    Container() /*AnimatedList(
              key: _myListKey,
              reverse: true,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              initialItemCount: _conversationList.conversations[0].chats.length,
              itemBuilder: (context, index, Animation<double> animation) {
                Chat chat = _conversationList.conversations[0].chats[index];
                return ChatMessageListItem(
                  chat: chat,
                  animation: animation,
                );
              },
            ),*/
                ),
            Container(
              height: 50,
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.transparent
                  // color: Theme.of(context).primaryColor,
                  // boxShadow: [
                  //   BoxShadow(
                  //       color: Theme.of(context).hintColor.withOpacity(0.10),
                  //       offset: Offset(0, -4),
                  //       blurRadius: 10)
                  // ],
                  ),
              child: Row(
                children: [
                  Expanded(
                    child: Material(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white,
                      shadowColor:
                          Theme.of(context).hintColor.withOpacity(0.30),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              // setState(() {
                              //   _conversationList.conversations[0].chats
                              //       .insert(0, new Chat(myController.text, '21min ago', _currentUser));
                              //   _myListKey.currentState.insertItem(0);
                              // });
                              Timer(Duration(milliseconds: 100), () {
                                myController.clear();
                              });
                            },
                            icon: Icon(
                              Icons.insert_emoticon,
                              color:
                                  Theme.of(context).hintColor.withOpacity(0.6),
                              size: 20,
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: myController,
                              focusNode: focusNode,
                              onSubmitted: (String value) {
                                Timer(Duration(milliseconds: 100), () {
                                  myController.clear();
                                  FocusScope.of(context)
                                      .requestFocus(focusNode);
                                });
                              },
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 5),
                                hintText: 'Chat text here',
                                hintStyle: TextStyle(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.8)),
                                /*
                              suffixIcon: IconButton(
                                onPressed: () {
                                  // setState(() {
                                  //   _conversationList.conversations[0].chats
                                  //       .insert(0, new Chat(myController.text, '21min ago', _currentUser));
                                  //   _myListKey.currentState.insertItem(0);
                                  // });
                                  Timer(Duration(milliseconds: 100), () {
                                    myController.clear();
                                  });
                                },
                                icon: Icon(
                                  Icons.attach_file,
                                  color: Theme.of(context).accentColor,
                                  size: 20,
                                ),
                              ),*/
                                // border: UnderlineInputBorder(borderSide: BorderSide.none),
                                // enabledBorder:
                                //     UnderlineInputBorder(borderSide: BorderSide.none),
                                // focusedBorder:
                                //     UnderlineInputBorder(borderSide: BorderSide.none),
                                border: new OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(40.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            padding: EdgeInsets.all(0),
                            onPressed: () {
                              Timer(Duration(milliseconds: 100), () {
                                myController.clear();
                              });
                            },
                            icon: Icon(
                              Icons.attach_file,
                              color:
                                  Theme.of(context).hintColor.withOpacity(0.6),
                              size: 25,
                            ),
                          ),
                          IconButton(
                            padding: EdgeInsets.all(0),
                            onPressed: () {
                              Timer(Duration(milliseconds: 100), () {
                                myController.clear();
                              });
                            },
                            icon: Icon(
                              Icons.camera_alt,
                              color:
                                  Theme.of(context).hintColor.withOpacity(0.6),
                              size: 25,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  FloatingActionButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    backgroundColor: Theme.of(context).accentColor,
                    elevation: 0,
                    onPressed: () => {},
                    child: Icon(
                      Icons.mic,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
            /*Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              boxShadow: [
                BoxShadow(
                    color: Theme.of(context).hintColor.withOpacity(0.10),
                    offset: Offset(0, -4),
                    blurRadius: 10)
              ],
            ),
            child: TextField(
              controller: myController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                hintText: 'Chat text here',
                hintStyle: TextStyle(
                    color: Theme.of(context).focusColor.withOpacity(0.8)),
                suffixIcon: IconButton(
                  padding: EdgeInsets.only(right: 30),
                  onPressed: () {
                    // setState(() {
                    //   _conversationList.conversations[0].chats
                    //       .insert(0, new Chat(myController.text, '21min ago', _currentUser));
                    //   _myListKey.currentState.insertItem(0);
                    // });
                    Timer(Duration(milliseconds: 100), () {
                      myController.clear();
                    });
                  },
                  icon: Icon(
                    UiIcons.cursor,
                    color: Theme.of(context).accentColor,
                    size: 20,
                  ),
                ),
                border: UnderlineInputBorder(borderSide: BorderSide.none),
                enabledBorder:
                    UnderlineInputBorder(borderSide: BorderSide.none),
                focusedBorder:
                    UnderlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
          ),*/
          ],
        ),
      ),
    );
  }
}
