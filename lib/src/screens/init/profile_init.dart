import 'dart:io';
import 'package:chatter/service_locator.dart';
import 'package:chatter/src/services/server.dart';
import 'package:chatter/src/services/user/owner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/services.dart';
import 'package:chatter/config/app_config.dart' as config;
import 'package:chatter/src/utils/ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class ProfileInitPage extends StatefulWidget {
  @override
  _ProfileInitPageState createState() => _ProfileInitPageState();
}

class _ProfileInitPageState extends State<ProfileInitPage> {
  GlobalKey<FormState> _profileSettingsFormKey = new GlobalKey<FormState>();
  File croppedImgFile;
  Image croppedImg;

  OwnerUserService userService;
  ServerService serverService;

  TextEditingController userNameController;
  String userName = "";

  @override
  void initState() {
    super.initState();
    
    userService = locator<OwnerUserService>();
    if (userService.user != null && userService.user.displayName != null) {
      userName = userService.user.displayName;
    }
    userNameController = TextEditingController(text: userName);

    serverService = locator<ServerService>();
  }
  
  Future getImage() async {
    var orgImageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (orgImageFile == null) return;

    croppedImgFile = await ImageCropper.cropImage(
      sourcePath: orgImageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        // CropAspectRatioPreset.ratio3x2,
        // CropAspectRatioPreset.original,
        // CropAspectRatioPreset.ratio4x3,
        // CropAspectRatioPreset.ratio16x9
      ],
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Cropper',
        toolbarColor: Theme.of(context).accentColor,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: true),
      iosUiSettings: IOSUiSettings(
        minimumAspectRatio: 1.0,
      )
    );
  
    if (croppedImgFile == null) return;

    setState(() {
      croppedImg = Image.file(croppedImgFile);
      userNameController.text = userName;
    });
  }

  void onDone() async {
    if (_profileSettingsFormKey.currentState.validate()) {
      UI.showSpinnerOverlay(context);
      //Save croppedImg and userName to server.
      String phoneNumber = userService.user.phoneNumber;
      Map<String, dynamic> uploadResult = await serverService.uploadProfileImage(phoneNumber, userName, croppedImgFile);
      if (uploadResult == null) {
        UI.closeSpinnerOverlay(context);
        return;
      }

      if (!uploadResult ["result"]) {
        UI.closeSpinnerOverlay(context);
        return;
      }

      String photoUrl = uploadResult ["data"]["imageUrl"];

      UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
      userUpdateInfo.displayName = userName;
      userUpdateInfo.photoUrl = photoUrl;

      await userService.update(userUpdateInfo);
      await userService.load();

      UI.closeSpinnerOverlay(context);
      Navigator.pushReplacementNamed(context, "/Tabs", arguments: 2);
    }
  }

  // void onLogout() {
  //   FirebaseAuth.instance.signOut();
  //   Navigator.pushNamedAndRemoveUntil(context, "/", ModalRoute.withName("/"));
  // }

  InputDecoration getInputDecoration({String hintText, String labelText}) {
    return new InputDecoration(
      hintText: hintText,
      labelText: labelText,
      hintStyle: Theme.of(context).textTheme.body1.merge(
        TextStyle(color: Theme.of(context).focusColor),
      ),
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).hintColor.withOpacity(0.2))),
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).hintColor)),
      hasFloatingPlaceholder: true,
      labelStyle: Theme.of(context).textTheme.body1.merge(
        TextStyle(color: Theme.of(context).hintColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.96),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Init Profile',
          style: Theme.of(context).textTheme.display3,
        ),
      ),
      body: 
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 15),
              
              Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    croppedImg == null ? FloatingActionButton(
                      onPressed: getImage,
                      tooltip: 'Pick Image',
                      child: Icon(Icons.add_a_photo),
                    ) :
                    GestureDetector(
                      onTap: getImage,
                      child: Container(
                        width: 100,
                        height: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: croppedImg,
                        ),
                      ),
                    ),
                    
                    Text(
                      'Profile Image',
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.body2,
                    ),
                  ],
                )
              ),

              SizedBox(height: 15),
              
              Form(
                key: _profileSettingsFormKey,
                child: Column(
                  children: <Widget>[
                    new TextFormField(
                      controller: userNameController,
                      style: TextStyle(color: Theme.of(context).hintColor),
                      keyboardType: TextInputType.text,
                      decoration: getInputDecoration(hintText: 'ChatterLover', labelText: 'User Name'),
                      // initialValue: userName,
                      validator: (input) => input.trim().length < 3 ? 'Not a valid full name' : null,
                      onChanged: (input) => setState(() { userName = input.isEmpty ? userName : input; }),
                    ),
                  ]
                ),
              ),

              Container(
                alignment: Alignment.centerRight,
                child:FlatButton(
                  onPressed: onDone,
                  child: Text(
                    'Done',
                    style: Theme.of(context).textTheme.button,
                  ),
                  color: Theme.of(context).accentColor,
                  shape: StadiumBorder(),
                ),
              ),
            ]
          )
        ),
      )
    );
  }
}