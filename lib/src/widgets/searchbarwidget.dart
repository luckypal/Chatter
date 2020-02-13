import 'package:chatter/config/ui_icons.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  final Function onChanged;
  final Function onSubmitted;
  final Function onClear;

  SearchBarWidget({Key key, this.onChanged, this.onSubmitted, this.onClear})
      : super(key: key);

  @override
  _SearchBarWidgetState createState() => new _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  TextEditingController controller;
  String searchText = "";

  @override
  void initState() {
    super.initState();
    controller = new TextEditingController();
  }

  void onChanged(String value) {
    setState(() {
      searchText = value;
      widget.onChanged != null && widget.onChanged(value);
    });
  }

  void onClear() {
    setState(() {
      searchText = "";
      controller.text = "";
      widget.onClear != null && widget.onClear();
      widget.onChanged != null && widget.onChanged("");
    });
  }

  void onSubmitted(String value) {
    setState(() {
      widget.onSubmitted != null && widget.onSubmitted(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).hintColor.withOpacity(0.10),
              offset: Offset(0, 4),
              blurRadius: 10)
        ],
      ),
      child: Stack(
        alignment: Alignment.centerRight,
        children: <Widget>[
          TextField(
            controller: controller,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(12),
              hintText: 'Input to search',
              hintStyle: TextStyle(
                  color: Theme.of(context).focusColor.withOpacity(0.8)),
              prefixIcon: Icon(UiIcons.loupe,
                  size: 20, color: Theme.of(context).hintColor),
              border: UnderlineInputBorder(borderSide: BorderSide.none),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
            ),
            onChanged: onChanged,
            onSubmitted: onSubmitted,
          ),
          IconButton(
            onPressed: onClear,
            icon: Icon(
              Icons.close,
              size: 20,
              color: Theme.of(context).hintColor.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}
