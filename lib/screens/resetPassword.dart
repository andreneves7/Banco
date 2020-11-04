import 'package:bankingApp/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:bankingApp/components/button.dart';
import 'package:bankingApp/components/input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../routes.dart';

class ResetPasswordPage extends StatefulWidget {
  static const String route = "/resetPassword";
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  TextEditingController _emailController = TextEditingController();

  final _auth = FirebaseAuth.instance;
  String errorMessage;

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
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Container(
                child: ButtonAuth(
                    "Repor palavra-passe",
                    Colors.white,
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor,
                    Colors.white, () {
                  resetPassword();
                }),
                height: 50,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void resetPassword() async {
    String email = _emailController.text;
    try {
      await _auth.sendPasswordResetEmail(email: email.trim()).then(
        (val) {
          setState(() {
            Fluttertoast.showToast(
              msg: 'pedido de reposição enviado com sucesso',
              toastLength: Toast.LENGTH_SHORT,
              //gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          });
          //Navigator.pushNamed(context, Routes.login);
          Navigator.of(context).pop();
        },
      );
    } catch (error) {
      print(error);
      switch (error.code) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "O formato do email está incorreto.";
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
          print(error.message);
          errorMessage = 'Email inválido';
      }

      setState(() {
        Fluttertoast.showToast(
          msg: errorMessage,
          toastLength: Toast.LENGTH_SHORT,
          //gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      });
    }
  }
}
