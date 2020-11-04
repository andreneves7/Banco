import 'package:bankingApp/screens/register.dart';
import 'package:bankingApp/screens/resetPassword.dart';
import 'package:flutter/material.dart';
import 'package:bankingApp/components/button.dart';
import 'package:bankingApp/components/input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../routes.dart';

class LoginPage extends StatefulWidget {
  static const String route = "/login";
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool _obscureTextLogin = true;

  String errorMessage;

  final _auth = FirebaseAuth.instance;
  String emailLogin, passwordLogin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 45.0),
              child: Image(
                  height: 100.0,
                  fit: BoxFit.fill,
                  image: new AssetImage('assets/bank.jpeg')),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 15, top: 50),
              child: InputAuth(
                Icon(Icons.email),
                "Email",
                _emailController,
                false,
                Theme.of(context).primaryColor,
                TextInputType.emailAddress,
                true,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: InputAuth(
                Icon(Icons.lock),
                "Palavra-passe",
                _passwordController,
                true,
                Theme.of(context).primaryColor,
                TextInputType.text,
                false,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Container(
                child: ButtonAuth(
                    "Login",
                    Colors.white,
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor,
                    Colors.white, () {
                  logUser();
                }),
                height: 50,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            FlatButton(
              onPressed: () {
                Navigator.pushNamed(context, RegisterPage.route);
              },
              child: Text(
                "Não tenho conta",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            FlatButton(
              onPressed: () {
                Navigator.pushNamed(context, ResetPasswordPage.route);
              },
              child: Text(
                "Esqueceu-se da palavra-passe?",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void logUser() async {
    emailLogin = _emailController.text;
    passwordLogin = _passwordController.text;
    try {
      final newUser = await _auth.signInWithEmailAndPassword(
          email: emailLogin.trim(), password: passwordLogin);
      if (newUser != null) {
        Navigator.pushReplacementNamed(context, Routes.selectAccount);
      }
    } catch (error) {
      print(error);
      switch (error.code) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "O formato do email está incorreto.";
          break;
        case "ERROR_WRONG_PASSWORD":
          errorMessage = "A password está incorreta.";
          break;
        case "ERROR_USER_NOT_FOUND":
          errorMessage = "Não existe nenhum utlizador associado a este email.";
          break;
        case "ERROR_USER_DISABLED":
          errorMessage = "O utilizador com este email foi desativado..";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Muitos pedidos. Por favor, tente mais tarde.";
          break;
        default:
          errorMessage = error.message;
      }

      setState(() {
        Fluttertoast.showToast(
            msg: errorMessage,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      });
    }
  }
}
