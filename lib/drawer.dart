import 'package:bankingApp/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawer createState() => _AppDrawer();
}

class _AppDrawer extends State<AppDrawer> {
  final auth = FirebaseAuth.instance;
  FirebaseUser user;
  String _userName = 'Vitor';
  String _email = 'vitor';

  @override
  void initState() {
    getUser();
    super.initState();
  }

  void getUser() async {
    user = await FirebaseAuth.instance.currentUser();
    setState(() {
      _email = user.email;
      _userName = user.displayName.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  'MyBank',
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.black87,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/bank.jpeg'),
                ),
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Adicionar Conta'),
              onTap: () {
                Navigator.pushReplacementNamed(context, Routes.addAccount);
              },
            ),
            /*ListTile(
              title: Text('Remover Conta'),
              onTap: () {
                Navigator.pushReplacementNamed(context, Routes.removeAccount);
              },
            ),*/
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Detalhes de Conta'),
              onTap: () {
                Navigator.pushReplacementNamed(context, Routes.selectAccount);
              },
            ),
            ListTile(
              leading: Icon(Icons.attach_money),
              title: Text('Efetuar pagamentos'),
              onTap: () {
                Navigator.pushReplacementNamed(context, Routes.makePayment);
              },
            ),
            /*ListTile(
              title: Text('Conteudo protegido'),
              onTap: () {
                Navigator.pushReplacementNamed(
                    context, Routes.protectedContent);
              },
            ),*/
            Divider(),
            ListTile(
              title: Text('Sair'),
              leading: Icon(Icons.exit_to_app),
              onTap: () {
                auth.signOut();
                setState(() {
                  Fluttertoast.showToast(
                    msg: 'Saiu da sua conta com sucesso',
                    toastLength: Toast.LENGTH_SHORT,
                    //gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.grey,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                });
                Navigator.pushReplacementNamed(context, Routes.login);
              },
            ),
          ],
        ),
      ),
    );
  }
}
