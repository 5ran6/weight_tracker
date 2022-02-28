import 'package:weight_tracker/imports/imports.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;
  int? id;
  late SharedPreferences? prefs;

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  void initState() {
//    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1))
          ..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller!, curve: Curves.easeIn);
    check();
  }

  void check() async {
    prefs = await SharedPreferences.getInstance();

    //first check if is first time (for onboarding) and check if logged in.

    Timer(
        Duration(seconds: 3),
        () => isFirstTime().then((isFirstTime) {
              print("Is First time?: " + isFirstTime.toString());
              isFirstTime
                  ? Navigator.pushReplacement(
                      context,
                      PageTransition(
                          duration: Duration(milliseconds: 600),
                          type: PageTransitionType.fade,
                          child: OnBoardingScreen()))
                  : checkIfLoggedIn();
            }));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      height: height,
      color: AppTheme.kPrimaryColor,
      child: Stack(
        children: [
          SafeArea(
            child: Scaffold(
              backgroundColor: AppTheme.kPrimaryColor,
              body: Column(
                children: [
                  Expanded(
                    child: FadeTransition(
                      opacity: _animation!,
                      child: Center(
                        child: Image.asset(
                          'assets/whitelogo.png',
                          width: 120.0,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ),
                  // Container(
                  //   padding: EdgeInsets.all(10 * 4.0),
                  //   color: Colors.transparent,
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     children: [
                  //       SpinKitRing(
                  //         color: AppTheme.kWhiteColor,
                  //         size: 30.0,
                  //         lineWidth: 1.2,
                  //       ),
                  //       SizedBox(
                  //         height: ScreenUtil().setHeight(20),
                  //       ),
                  //
                  //       Text(
                  //         'Welcome to Cura Health',
                  //         style: AppTheme.kBodyTextStyle,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> isFirstTime() async {
    var isFirstTime = prefs!.getBool('onboarded');
    print("Onboarded?: " + isFirstTime.toString());
    if (isFirstTime != null && isFirstTime) {
      return false;
    } else {
      return true;
    }
  }

  checkIfLoggedIn() async {
    var isLoggedIn = prefs!.getBool('loggedIn');
    if (isLoggedIn != null && isLoggedIn) {
      prefs!.setBool('loggedIn', true);
      id = prefs!.getInt('id');
      //goto Dashboard
      if (id != null) {
        Navigator.pushReplacement(
            context,
            PageTransition(
                duration: Duration(milliseconds: 600),
                type: PageTransitionType.fade,
                child: Dashboard()));
      } else {
        Navigator.pushReplacement(
            context,
            PageTransition(
                duration: Duration(milliseconds: 600),
                type: PageTransitionType.fade,
                child: Auth()));
      }
    } else {
      //goto Login page
      Navigator.pushReplacement(
          context,
          PageTransition(
              duration: Duration(milliseconds: 600),
              type: PageTransitionType.fade,
              child: Auth()));
    }
  }
}
