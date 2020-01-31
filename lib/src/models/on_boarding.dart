class OnBoarding {
  String image;
  String description;

  OnBoarding({this.image, this.description});
}

class OnBoardingList {
  List<OnBoarding> _list;

  List<OnBoarding> get list => _list;

  OnBoardingList() {
    _list = [
      new OnBoarding(
          image: 'assets/images/onboarding0.png',
          description:
              'Connect your fan messenger account and use them.'),
      new OnBoarding(
          image: 'assets/images/onboarding1.png',
          description: 'Be yourself, everyone else is already taken.'),
      new OnBoarding(
          image: 'assets/images/onboarding2.png',
          description: 'Businesses and life with one click.'),
      new OnBoarding(
          image: 'assets/images/onboarding3.png',
          description: 'A room with different messenger users.'),
      new OnBoarding(
          image: 'assets/images/onboarding4.png',
          description: 'Read our Private Policy, and tap "Agree & Continue" to accept the Terms of Service.'),
    ];
  }
}
