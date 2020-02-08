import 'package:flutter/material.dart';

@immutable
class ContactCircleAvatar extends StatefulWidget {
  final NetworkImage image;
  final String displayName;

  ContactCircleAvatar({this.image, this.displayName});

  @override
  _ContactCircleAvatarState createState() => new _ContactCircleAvatarState();
}

class _ContactCircleAvatarState extends State<ContactCircleAvatar> {
  bool _checkLoading = true;
  String initialName;
  Color color;

  @override
  void initState() {
    super.initState();

    initialName = getInitialName(widget.displayName);
    color = colorFor(widget.displayName);

    widget.image
        .resolve(new ImageConfiguration())
        .addListener(new ImageStreamListener((ImageInfo _, bool __) {
      if (mounted) setState(() => _checkLoading = false);
    }));
  }

  String getInitialName(String displayName) {
    var matches = RegExp(r"\b\w").allMatches(displayName);
    String initialName = "";
    matches.forEach((match) {
      if (initialName.length >= 2) return;
      initialName += match.group(0).toUpperCase();
    });
    return initialName;
  }

  Color colorFor(String text) {
    var hash = 0;
    for (var i = 0; i < text.length; i++) {
      hash = text.codeUnitAt(i) + ((hash << 5) - hash);
    }
    final finalHash = hash.abs() % (256 * 256 * 256);
    print(finalHash);
    final red = ((finalHash & 0xFF0000) >> 16);
    final blue = ((finalHash & 0xFF00) >> 8);
    final green = ((finalHash & 0xFF));
    final color = Color.fromRGBO(red, green, blue, 1);
    return color;
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(child: new Text(initialName), backgroundColor: color);

    return _checkLoading == true
        ? new CircleAvatar(child: new Text(initialName))
        : new CircleAvatar(
            backgroundImage: widget.image,
          );
  }
}
