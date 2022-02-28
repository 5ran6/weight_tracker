import 'package:weight_tracker/imports/imports.dart';

class Api {
//firebase instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

// create user object based on firebase user
  Users? _userFromFirebaseUser(User? user) {
    return user != null ? Users(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<Users?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // sign in anon
  Future signInAnon() async {
    try {
      User? user = (await _auth.signInAnonymously()).user;
      print(user.toString());
      await SharedPreferences.getInstance().then((prefs) async {
        prefs.setBool('loggedIn', true);
        prefs.setString('id', user!.uid);
        print ("shared pref data saved");  //TODO: remove after debugging
        return _userFromFirebaseUser(user);
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // logout
  Future signOut() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear().then((value) async {
        return await _auth.signOut();
      });
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
