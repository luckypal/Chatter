import 'dart:async';
import 'dart:io' show Platform;

import 'package:chatter/config/ui_icons.dart';
import 'package:chatter/service_locator.dart';
import 'package:chatter/src/models/conversation.dart/base.dart';
import 'package:chatter/src/models/message/base.dart';
// import 'package:chatter/src/models/contact.dart';
// import 'package:chatter/src/models/chat.dart';
// import 'package:chatter/src/models/conversation.dart';
import 'package:chatter/src/models/user/base.dart';
import 'package:chatter/src/services/conversation/multi.dart';
// import 'package:chatter/src/widgets/ChatMessageListItemWidget.dart';
import 'package:flutter/material.dart';
// import 'package:intent/intent.dart' as AndroidIntent;
import 'package:intent/action.dart' as AndroidIntentActions;
import 'package:android_intent/android_intent.dart';

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

class ChatPage extends StatefulWidget {
  final int platform;
  final String title;
  final List<UserModel> contacts;
  ConversationModel model;

  ChatPage({Key key, this.platform, this.title, this.contacts})
      : super(key: key);

  ChatPage.fromModel(ConversationModel model, {Key key})
      : platform = model.platform,
        title = model.title,
        contacts = model.userModel,
        model = model,
        super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  MultiConversationService multiConversationService;

  final List<Choice> choices = const <Choice>[
    const Choice(title: '', icon: Icons.videocam),
    const Choice(title: '', icon: Icons.phone),
    const Choice(title: 'View Contact', icon: Icons.contacts),
    const Choice(title: 'Media, links, and docs', icon: Icons.perm_media),
    const Choice(title: 'Search', icon: Icons.search),
    const Choice(title: 'Mute notifications', icon: Icons.notifications_off),
    const Choice(title: 'Wallpaper', icon: Icons.wallpaper),
    const Choice(title: 'More', icon: Icons.more_horiz),
  ];

  final _myListKey = GlobalKey<AnimatedListState>();
  final myController = TextEditingController();
  final focusNode = new FocusNode();
  ConversationModel conversationModel;

  Stream<int> testStream;

  @override
  void initState() {
    super.initState();
    conversationModel = widget.model;
    multiConversationService = locator<MultiConversationService>();

    testStream = Stream<int>.periodic(Duration(seconds: 1), (x) => x).take(15);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  void _selectMenu(Choice choice) {
    if (choice.icon == Icons.contacts) {
      //Show contact
      if (Platform.isAndroid) {
        String identifier = widget.contacts[0].identifier;

        AndroidIntent intent = AndroidIntent(
          action: AndroidIntentActions.Action.ACTION_EDIT,
          data: 'content://contacts/people/$identifier',
          type: "vnd.android.cursor.item/contact",
        );
        intent.launch();
      }
    }
    setState(() {});
  }

  void sendMessage(String message, int messageType) async {
    if (conversationModel == null)
      conversationModel = await multiConversationService.createConversation(
          widget.title, widget.contacts, widget.platform);

    MessageModel messageModel = await multiConversationService.sendMessage(
        conversationModel, message, messageType);

    Timer(Duration(milliseconds: 100), () {
      myController.clear();
      FocusScope.of(context).requestFocus(focusNode);
    });
  }

  Widget buildTitleWidget() {
    if (widget.contacts.length == 1) {
      UserModel contact = widget.contacts[0];
      return Row(
        children: [
          CircleAvatar(backgroundImage: Image.network(contact.photoUrl).image),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                contact.userName,
                style: Theme.of(context).textTheme.display1,
              ),
              Text("Last seen at yesterday.",
                  style: Theme.of(context).textTheme.body1),
            ],
          ),
        ],
      );
    } else {
      List<Widget> contactWidgets = List<Widget>();
      widget.contacts.forEach((contact) {
        contactWidgets.add(
          Row(children: [
            SizedBox(
              width: 15,
              height: 15,
              child: CircleAvatar(
                backgroundImage: Image.network(contact.photoUrl).image,
              ),
            ),
            Text(
              contact.userName,
              style: Theme.of(context).textTheme.body1,
            ),
            SizedBox(
              width: 7,
            )
          ]),
        );
      });

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: Theme.of(context).textTheme.display1,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: contactWidgets,
            ),
          ),
          // Text("Last seen at yesterday.",
          //     style: Theme.of(context).textTheme.body1),
        ],
      );
    }
  }

  Widget buildInputBox() {
    return Container(
      height: 50,
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50), color: Colors.transparent),
      child: Row(
        children: [
          Expanded(
            child: Material(
              borderRadius: BorderRadius.circular(50),
              color: Colors.white,
              shadowColor: Theme.of(context).hintColor.withOpacity(0.30),
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
                      color: Theme.of(context).hintColor.withOpacity(0.6),
                      size: 20,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: myController,
                      focusNode: focusNode,
                      onSubmitted: (String value) =>
                          sendMessage(value, MessageType.TEXT),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 5),
                        hintText: 'Chat text here',
                        hintStyle: TextStyle(
                          color: Theme.of(context).focusColor.withOpacity(0.8),
                        ),
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
                      color: Theme.of(context).hintColor.withOpacity(0.6),
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
                      color: Theme.of(context).hintColor.withOpacity(0.6),
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
    );
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
        title: buildTitleWidget(),
        actions: <Widget>[
          // new IconButton(
          //   icon: new Icon(choices[0].icon, color: Theme.of(context).hintColor),
          //   onPressed: () => _select(choices[0]),
          // ),
          // new IconButton(
          //   icon: new Icon(Icons.phone, color: Theme.of(context).hintColor),
          //   onPressed: () => _select(choices[1]),
          // ),
          PopupMenuButton<Choice>(
            onSelected: _selectMenu,
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
              child: widget.model != null ? Container(
                child: multiConversationService.streamBuilder(key: _myListKey, conversationModel: widget.model)
              ) : Container(),
              /*AnimatedList(
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
            buildInputBox(),
          ],
        ),
      ),
    );
  }
}
