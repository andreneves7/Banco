import 'package:bankingApp/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:bankingApp/components/button.dart';
import 'package:bankingApp/components/input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../routes.dart';

class RegisterPage extends StatefulWidget {
  static const String route = "/register";
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _email;
  String _password;
  String _name;
  String _confirmPassword;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  bool _obscureTextLogin = true;
  final _auth = FirebaseAuth.instance;
  String errorMessage;
  bool existMesssage = false;

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
              padding: EdgeInsets.only(bottom: 15, top: 30),
              child: InputAuth(
                Icon(Icons.account_circle),
                "Nome",
                _nameController,
                false,
                Theme.of(context).primaryColor,
                TextInputType.text,
                true,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: InputAuth(
                Icon(Icons.email),
                "Email",
                _emailController,
                false,
                Theme.of(context).primaryColor,
                TextInputType.emailAddress,
                false,
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
            Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: InputAuth(
                Icon(Icons.lock),
                "Confirmar Palavra-passe",
                _confirmPasswordController,
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
                    "Registar",
                    Colors.white,
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor,
                    Colors.white, () {
                  _registerUser();
                }),
                height: 50,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            FlatButton(
              onPressed: () {
                //Navigator.pushReplacementNamed(context, LoginPage.route);
                Navigator.of(context).pop();
              },
              child: Text(
                "Já tenho conta",
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

  void _registerUser() async {
    _email = _emailController.text;
    _password = _passwordController.text;
    _confirmPassword = _confirmPasswordController.text;
    _name = _nameController.text;
    if (_email != "" &&
        _password != "" &&
        _confirmPassword != "" &&
        _name != "") {
      if (_confirmPassword == _password) {
        try {
          final newUser = await _auth.createUserWithEmailAndPassword(
              email: _email.trim(), password: _password);
          if (newUser != null) {
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.addAccount, (route) => route is LoginPage);
            //Navigator.pushReplacementNamed(context, Routes.addAccount);
          }
        } catch (error) {
          print(error);
          switch (error.code) {
            case "ERROR_INVALID_EMAIL":
              errorMessage = "O formato do email está incorreto.";
              break;
            case "ERROR_WEAK_PASSWORD":
              errorMessage = "A Password deve ter pelo menos 6 carácteres.";
              break;
            case "ERROR_EMAIL_ALREADY_IN_USE":
              errorMessage = "Este email já tem uma conta associada.";
              break;
            case "ERROR_TOO_MANY_REQUESTS":
              errorMessage = "Muitos pedidos. Por favor, tente mais tarde.";
              break;
            default:
              errorMessage = error.message;
          }
          existMesssage = true;
        }
      } else {
        errorMessage = "Passwords são diferentes";
        existMesssage = true;
      }
    } else {
      errorMessage = "Os campos não estão todos preenchidos";
      existMesssage = true;
    }
    if (existMesssage) {
      existMesssage = false;
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
