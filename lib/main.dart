import 'package:bankingApp/accountDetails.dart';
import 'package:bankingApp/addAccount.dart';
import 'package:bankingApp/makePayment.dart';
import 'package:bankingApp/protectedContent.dart';
import 'package:bankingApp/screens/login.dart';
import 'package:bankingApp/screens/register.dart';
import 'package:bankingApp/screens/resetPassword.dart';
import 'package:bankingApp/selectAccount.dart';
import 'package:flutter/material.dart';
import 'routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'splash.dart';

final auth = FirebaseAuth.instance;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        //const Locale('en'), // English
        const Locale('pt'),
      ],
      title: 'MyBank',
      debugShowCheckedModeBanner: false,
      /*theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: "Montserrat",
        canvasColor: Colors.transparent,
      ),*/
      theme: ThemeData.light(),
      home: Splash(),
      /*new StreamBuilder(
        stream: auth.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MakePayment();
          }
          return LoginPage();
        },
      ),*/
      routes: <String, WidgetBuilder>{
        Routes.login: (BuildContext context) => new LoginPage(),
        Routes.register: (BuildContext context) => new RegisterPage(),
        Routes.resetPassword: (BuildContext context) => new ResetPasswordPage(),
        Routes.accountDetails: (BuildContext context) => new AccountDetails(),
        Routes.selectAccount: (BuildContext context) => new SelectAccount(),
        Routes.addAccount: (BuildContext context) => new AddAccount(),
        //Routes.removeAccount: (BuildContext context) => new RemoveAccount(),
        Routes.makePayment: (BuildContext context) => new MakePayment(),
        Routes.protectedContent: (BuildContext context) =>
            new ProtectedContent(),
      },
    );
  }
}
