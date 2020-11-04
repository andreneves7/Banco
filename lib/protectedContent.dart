import 'package:bankingApp/addAccount.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'routes.dart';
import 'drawer.dart';

class ProtectedContent extends StatefulWidget {
  @override
  _ProtectedContentState createState() => _ProtectedContentState();
}

class _ProtectedContentState extends State<ProtectedContent> {
  final LocalAuthentication auth = LocalAuthentication();

  @override
  initState() {
    super.initState();
    authenticate();
  }

  authenticate() async {
    try {
      if (await _isBiometricAvailable()) {
        await _getAvailableBiometrics();
        await _authenticateUser();
      } else {
        print('No biometrics Available');
      }
    } catch (ex) {
      print(ex);
    }
  }

  Future<bool> _isBiometricAvailable() async {
    try {
      bool isAvailable = await auth.canCheckBiometrics; //if have biometrics
      return isAvailable;
    } catch (ex) {
      print(ex);
      return false;
    }
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> listAvailableBiometrics;
    try {
      listAvailableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> _authenticateUser() async {
    bool isAuthenticated = false;
    try {
      isAuthenticated = await auth.authenticateWithBiometrics(
        localizedReason:
            'Use a biometria para aceder ás informações da sua conta',
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } on PlatformException catch (e) {
      print(e);
    }

    if (isAuthenticated) {
      Navigator.of(context).pushReplacementNamed(Routes.selectAccount);
      /*Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AddAccount(),
        ),
      );*/
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      //drawer: AppDrawer(),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Use a impressão digital para prosseguir'),
              SizedBox(
                height: 10,
              ),
              Text('(pressione aqui)'),
              IconButton(
                icon: Icon(
                  FontAwesomeIcons.fingerprint,
                  size: 40,
                  color: Colors.blue,
                ),
                onPressed: () {
                  try {
                    authenticate();
                  } catch (ex) {
                    print(ex);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
