import 'package:weight_tracker/imports/imports.dart';

class Dashboard extends StatefulWidget {
  late final user;

  Dashboard(user) {
    this.user = user;
  }

  @override
  _DashboardState createState() => _DashboardState();
}
//{"uid":"uWuT5sH0d1aVO4eZA2s45Q9WJGj2","displayName":null,"email":null,"emailVerified":false,"isAnonymous":true,"phoneNumber":null,"photoURL":null,"refreshToken":""}
class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      child: Text(widget.user["uid"]),
    ));
  }
}
