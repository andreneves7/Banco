import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'drawer.dart';
import 'bankData.dart';
import 'package:http/http.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'routes.dart';

class RemoveAccount extends StatefulWidget {
  @override
  _RemoveAccountState createState() => _RemoveAccountState();
}

class _RemoveAccountState extends State<RemoveAccount> {
  bool _isLoading = true;
  final userId = '4sada4564ad65as4d';
  final dbRef = Firestore.instance;
  String accountId = "";
  List<String> accounts;

  _removeAccount(myAccountId) async {
    try {
      await dbRef.collection('bankAccounts').document(myAccountId).delete();
    } catch (e) {
      print(e);
    }
  }

  _getMyAccounts() async {
    List<String> userAccounts = List();
    dbRef
        .collection('bankAccounts')
        .where('user_id', isEqualTo: userId)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((account) {
        userAccounts.add(account.data['account_id']);
        //print(account.data);
      });
      //print(userAccounts);

      //var accounts = userAccounts.map((account) => account.account_id);
      print(userAccounts);
      setState(() {
        accountId = userAccounts[0];
        _isLoading = false;
        accounts = userAccounts;
      });
      /*if (userAccounts.length > 0) {
        Navigator.pushReplacementNamed(context, Routes.accountDetails,
            arguments: {'accountId': userAccounts[0], 'accountId': accountId});
      }*/
    });
  }

  @override
  void initState() {
    super.initState();
    _getMyAccounts();
  }

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    int accountIndex = 0;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Remover conta'),
        ),
        drawer: AppDrawer(),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(
                height: 9,
              ),
              Text('A carregar...'),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Remover Conta'),
        ),
        drawer: AppDrawer(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              DropdownButton(
                dropdownColor: Colors.white,
                focusColor: Colors.blue,
                value: accountId,
                //icon: Icon(FontAwesomeIcons.piggyBank),
                iconSize: 24,
                elevation: 16,
                onChanged: (String newValue) {
                  setState(() {
                    accountId = newValue;
                  });
                },
                /*items: <String>['One', 'Two', 'Three']
                      .map<DropdownMenuItem<String>>(
                          (String bank) => DropdownMenuItem<String>(
                                value: bank,
                                child: Text(bank),
                              ))
                      .toList(),*/
                items: accounts.map<DropdownMenuItem<String>>((account) {
                  accountIndex++;
                  return DropdownMenuItem<String>(
                    value: account,
                    child: Text("Conta $accountIndex"),
                  );
                }).toList(),
              ),
              RaisedButton(
                color: Colors.blue,
                child: Text('Remover conta'),
                onPressed: () {
                  print(accountId);

                  _removeAccount(accountId);

                  setState(() {
                    _isLoading = true;
                  });
                  _getMyAccounts();
                  _scaffoldKey.currentState.showSnackBar(
                    SnackBar(
                      content: Text('Conta removida'),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      );
    }
  }
}
