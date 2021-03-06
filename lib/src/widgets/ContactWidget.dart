import 'package:flutter/material.dart';
import 'package:chatter/src/models/user/base.dart';

@immutable
class ContactWidget extends StatefulWidget {
  final UserModel contact;
  final Function onPressed;
  final Function onLongPressed;
  final bool isSelected;

  ContactWidget(
      {this.contact,
      this.onPressed,
      this.onLongPressed,
      this.isSelected = false});

  @override
  _ContactWidgetState createState() => new _ContactWidgetState();
}

class _ContactWidgetState extends State<ContactWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      onLongPress: widget.onLongPressed,
      // elevation: 0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        color: widget.isSelected ? Theme.of(context).focusColor.withOpacity(0.2) : Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: [
                CircleAvatar(
                  backgroundImage: Image.network(widget.contact.photoUrl).image,
                ),
                widget.isSelected
                    ? Positioned.fill(
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Material(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.white,
                            child: Icon(
                              Icons.check,
                              color: Colors.green,
                              size: 15,
                            ),
                          ),
                        ),
                      )
                    : Material(),
              ],
            ),
            SizedBox(width: 15),
            Expanded(
              child: Text(
                widget.contact.userName,
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
