import 'package:weight_tracker/imports/imports.dart';

class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final Api _api = Api();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text("Weight Tracker"),
            ),
            body: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text("Welcome",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              fontFamily: 'Roboto')),
                    ),

                    Padding(
                        padding: EdgeInsets.all(10.0),
                        child: SignInButton(
                          Buttons.Google,
                          text: "Sign up with Google",
                          onPressed: ()async{
                           await _api.signInAnon().then((user) async{
                             if(user == null){
                               print('error signing in');
                             } else {
                               print('signed in');
                               print(user.uid);
                               Navigator.of(context).push(
                                 MaterialPageRoute(
                                   builder: (_) => Dashboard(user),
                                 ),
                               );

                             }
                           });
                          },
                        )),


                  ]),
            )));
  }
}
