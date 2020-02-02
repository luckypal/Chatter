import 'package:carousel_slider/carousel_slider.dart';
import 'package:chatter/service_locator.dart';
import 'package:chatter/src/services/phone_verify.dart';
import 'package:chatter/src/services/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chatter/config/app_config.dart' as config;
import 'package:chatter/src/models/on_boarding.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  int _current = 0;
  OnBoardingList _onBoardingList;
  CarouselSlider slider;

  @override
  void initState() {
    _onBoardingList = new OnBoardingList();
    slider = getSlider();
    super.initState();
    
    /*UserService userService = locator<UserService>();
    userService.load().then((FirebaseUser user) {
      if (userService.user != null) {
        if (userService.user.displayName == null)
          Navigator.pushReplacementNamed(context, "/ProfileInit");
        else
          Navigator.pushReplacementNamed(context, "/Tabs", arguments: 2);
      }
    });*/
  }

  onSkip() {
    slider.animateToPage(lastPageIndex(),
        duration: slider.autoPlayAnimationDuration,
        curve: slider.autoPlayCurve);
  }

  onNext() {
    if (isLastPage()) {
      onContinue();
    } else
      slider.nextPage(
          duration: slider.autoPlayAnimationDuration,
          curve: slider.autoPlayCurve);
  }

  onContinue() {
    // Navigator.of(context).pushReplacementNamed('/InputPhone');
    Navigator.of(context).pushNamed('/PhoneInput');
  }

  isLastPage() {
    return _current == lastPageIndex();
  }

  lastPageIndex() {
    return _onBoardingList.list.length - 1;
  }

  getSlider() {
    return CarouselSlider(
      enableInfiniteScroll: false,
      height: 500.0,
      viewportFraction: 1.0,
      onPageChanged: (index) {
        setState(() {
          _current = index;
        });
      },
      items: _onBoardingList.list.map((OnBoarding boarding) {
        return Builder(
          builder: (BuildContext context) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Image.asset(
                    boarding.image,
                    width: 500,
                  ),
                ),
                Container(
                  width: config.App(context).appWidth(75),
                  padding: const EdgeInsets.only(right: 20),
                  child: Text(
                    boarding.description,
                    style: Theme.of(context).textTheme.display1,
                  ),
                ),
              ],
            );
          },
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.96),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20, top: 50),
              child: FlatButton(
                onPressed: isLastPage() ? null : onSkip,
                child: Text(
                  'Skip',
                  style: Theme.of(context).textTheme.button,
                ),
                color: Theme.of(context).accentColor,
                shape: StadiumBorder(),
              ),
            ),
            slider,
            Container(
              width: config.App(context).appWidth(75),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: _onBoardingList.list.map((OnBoarding boarding) {
                  return Container(
                    width: 25.0,
                    height: 3.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                        color:
                            _current == _onBoardingList.list.indexOf(boarding)
                                ? Theme.of(context).hintColor.withOpacity(0.8)
                                : Theme.of(context).hintColor.withOpacity(0.2)),
                  );
                }).toList(),
              ),
            ),
            Container(
              width: config.App(context).appWidth(75),
              padding: EdgeInsets.only(top: 50),
              child: FlatButton(
                padding: EdgeInsets.symmetric(horizontal: 35, vertical: 12),
                onPressed: this.onNext,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      _current != lastPageIndex() ? 'Next' : 'Agree & Continue',
                      style: Theme.of(context).textTheme.display1.merge(
                            TextStyle(color: Theme.of(context).primaryColor),
                          ),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
                color: Theme.of(context).accentColor,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.only(
                    topLeft: Radius.circular(50),
                    bottomLeft: Radius.circular(50),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
