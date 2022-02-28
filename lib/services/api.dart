import 'package:weight_tracker/imports/imports.dart';
import 'package:http/http.dart' as http;

class Api {
  bool debug = true;

  //#-----Accounts-------------------------------------------------------------------------------------------------

//create user
  Future<Map?> signUp(String email, String mobile, String password) async {
    Map data = {'email': email, 'mobile': mobile, 'password': password};
    SharedPreferences prefs = await SharedPreferences.getInstance();


    /*Calling the API url */
    var jsonData;
    final response = await http.post(
        Uri.parse("/accounts/auth/users"),
        body: data,
    );
    if (debug) {
      print('Status Code = ' +
          response.statusCode.toString() +
          ". Response: " +
          response.body);
    }

    /*If the response is 200 or 201 (success) then the response will be decoded */
    if (response.statusCode == 200 || response.statusCode == 201) {
      jsonData = json.decode(response.body);

      prefs.setString('email', jsonData["email"]);
      prefs.setString('mobile', jsonData["mobile"]);
      prefs.setString('referralCode', jsonData["referralCode"]);
      prefs.setString('username', jsonData["username"]);
      prefs.setInt('id', jsonData["id"]);

      return {
        "email": jsonData["email"],
        "mobile": jsonData["mobile"],
        "referralCode": jsonData["referralCode"],
        "username": jsonData["username"],
        "id": jsonData["id"]
      };
    } else if (response.statusCode == 400){
      return {
        "error": jsonData["password"],
      };
    }else {
      if (debug) print("Error Requesting API");
      return null;
    }
  }

  // logout
  Future<bool?> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear().then((value) {
      return true;
    });
  }

}