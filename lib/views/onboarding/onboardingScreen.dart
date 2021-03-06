import 'package:weight_tracker/imports/imports.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}


class _OnBoardingScreenState extends State<OnBoardingScreen> {

  late SharedPreferences prefs;
  List<OnBoardingItem> onBoardItems = [
    OnBoardingItem(
      imageAsset: "assets/onboard2.png",
      title: """Health 
is wealth""",
      description:
          """Ensure you are healthy at all time""",
    ),
    OnBoardingItem(
      imageAsset: "assets/onboard1.png",
      title: """Any where,
any time""",
      description:
          """Keep a track record of your weight on the go.

""",
    ),
    OnBoardingItem(
      imageAsset: "assets/onboard3.png",
      title: "Secured Record",
      description:
          "Safely store your weight records in the cloud",
    ),
  ];
  final int _numberOfPages = 2;
  final _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.kWhiteColor,
      body: Container(
        height: screenHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: ScreenUtil().setHeight(110),
              padding: EdgeInsets.all(
                ScreenUtil().setHeight(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: getStarted,
                    child: Text(
                      "Skip",
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          color: AppTheme.kPrimaryColor,
                          fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: ScreenUtil().setHeight(490),
              color: AppTheme.kWhiteColor,
              child: PageView(
                physics: BouncingScrollPhysics(),
                controller: _pageController,
                onPageChanged: (int value) {
                  setState(() {
                    _currentPage = value;
                  });
                },
                children: onBoardItems,
              ),
            ),
            Container(
              height: ScreenUtil().setHeight(90),
              padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(10),
                  vertical: ScreenUtil().setHeight(10)),
              color: AppTheme.kWhiteColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: buildPageIndicator(),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 250),
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(
                              kDefaultButtonRadius,
                            ),
                          ),
                          height: _currentPage != _numberOfPages
                              ? ScreenUtil().setHeight(55)
                              : ScreenUtil().setHeight(55),
                          width: _currentPage != _numberOfPages
                              ? ScreenUtil().setWidth(60)
                              : ScreenUtil().setWidth(120),
                          child: TextButton(
                            //style: onBoardingButtonStyle,
                            child: Center(
                              child: Padding(
                                padding:
                                    EdgeInsets.all(ScreenUtil().setWidth(6)),
                                child: Text(
                                  _currentPage != _numberOfPages
                                      ? "Next"
                                      : "Get Started",
                                  style: Theme.of(context)
                                      .textTheme
                                      .button
                                      ?.copyWith(
                                          fontWeight: FontWeight.normal,
                                          fontSize: ScreenUtil().setSp(11)),
                                ),
                              ),
                            ),
                            onPressed: _currentPage != _numberOfPages
                                ? moveToNextItem
                                : getStarted,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i <= _numberOfPages; i++) {
      list.add(i == _currentPage ? pageIndicator(true) : pageIndicator(false));
    }
    return list;
  }

  moveToNextItem() {
    _pageController.nextPage(
        duration: Duration(milliseconds: 750), curve: Curves.ease);
  }

  getStarted() async {
    prefs = await SharedPreferences.getInstance();
    prefs
        .setBool("onboarded", true)
        .then((value) => Navigator.pushReplacement(
        context,
        PageTransition(
            duration: Duration(milliseconds: 600),
            type: PageTransitionType.fade,
            child: Auth())));
  }
}
