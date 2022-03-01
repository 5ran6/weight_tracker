import 'package:weight_tracker/imports/imports.dart';

class Dashboard extends StatefulWidget {
  late final user;

  Dashboard(user) {
    this.user = user;
  }

  @override
  _DashboardState createState() => _DashboardState();
}


class _DashboardState extends State<Dashboard> {
final  Api _api = Api();


@override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Weight Tracker")),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
              await _api.signOut().then((value) {
                print(value.toString());
                if (value != "error"){
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => Auth(),
                    ),
                  );
                }else{
                  //something went wrong
                  CoolAlert.show(
                    context: context,
                    type: CoolAlertType.error,
                    text: "Sign Out unsuccessful! Try again later.",
                  );
                }
              });
              },
            ),
          ],
          leading: IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              /** Do something */
            },
          ),
        ),
        body: Container(
          child: Text(widget.user["uid"]),
        ));
  }
}
