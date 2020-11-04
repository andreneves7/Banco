import 'package:bankingApp/protectedContent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'routes.dart';
import 'screens/login.dart';
import 'selectAccount.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  var isLoggedIn = false;

  userIdLoggedIn() async {
    if (await FirebaseAuth.instance.currentUser() != null) {
      isLoggedIn = true;
    } else {
      isLoggedIn = false;
    }
  }

  @override
  void initState() {
    super.initState();
    userIdLoggedIn();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    Future.delayed(Duration(seconds: 3)).then((_) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  isLoggedIn ? ProtectedContent() : LoginPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 200,
              height: 200,
              child: Image.asset("assets/bank.jpeg"),
            ),
            SizedBox(
              height: 25,
            ),
            CircularProgressIndicator(
              strokeWidth: 4,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              backgroundColor: Colors.black12,
            ),
          ],
        ),
      ),
    );
  }
}
