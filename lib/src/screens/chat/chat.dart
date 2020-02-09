import 'dart:async';

import 'package:chatter/config/ui_icons.dart';
import 'package:chatter/src/models/contact.dart';
// import 'package:chatter/src/models/chat.dart';
// import 'package:chatter/src/models/conversation.dart';
import 'package:chatter/src/models/user.dart';
// import 'package:chatter/src/widgets/ChatMessageListItemWidget.dart';
import 'package:flutter/material.dart';

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

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
