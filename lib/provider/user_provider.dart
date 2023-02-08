import 'package:flutter/foundation.dart';
import 'package:instagram_clone/model/user.dart';
import 'package:instagram_clone/resources/auth_methods.dart';

class UserProvider with  ChangeNotifier{
  User ? _user;
  User get getUser => _user!;
  final AuthMethods _authMethods =AuthMethods();




  Future<void>refreshUser()async{
    User user = await _authMethods.getUserDetails();
    _user= user;
    notifyListeners();

  }
}