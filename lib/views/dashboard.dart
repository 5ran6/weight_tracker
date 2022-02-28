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
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      child: Text(widget.user.toString()),
    ));
  }
}
