import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'drawer.dart';
import 'bankData.dart';
import 'package:http/http.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'routes.dart';

class AddAccount extends StatefulWidget {
  @override
  _AddAccountState createState() => _AddAccountState();
}

class _AddAccountState extends State<AddAccount> {
  final dbRef = Firestore.instance;
  static final auth = FirebaseAuth.instance;
  String bankCode = "ABPT";
  final _formKey = GlobalKey<FormState>();
  final ibanTextEditingController = TextEditingController();
  String bankNameSelected = "BANCO ACTIVOBANK, SA";
  List<String> accountsIds = new List();

  static String userId;
  var user = auth.currentUser().then((FirebaseUser user) {
    userId = user.uid;
    print('userId: $userId');
  });

  _saveAccount(myAccountId) async {
    //DocumentReference ref =
    await dbRef.collection('bankAccounts').document(myAccountId).setData({
      'user_id': userId,
      'account_id': myAccountId,
      'account_iban': ibanTextEditingController.text,
      'bank_code': bankCode,
      'bank_name': bankNameSelected
    });
    //print(ref.documentID);
    //return ref;
  }

  _getMyAccounts() async {
    List<String> userAccounts = new List();
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
      accountsIds = userAccounts;
      print(userAccounts);
      /*if (userAccounts.length > 0) {
        Navigator.pushReplacementNamed(context, Routes.accountDetails,
            arguments: {'accountId': userAccounts[0], 'bankCode': bankCode});
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
    List<String> accountIdsAdded = List();
    final _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Adicionar Conta'),
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: new Container(
          margin: EdgeInsets.all(15.0),
          child: new Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: ibanTextEditingController,
                  maxLength: 25,
                  validator: (value) {
                    if (value.trim().isEmpty) return 'Preencha o IBAN';
                    if (value.trim().length != 25) return 'IBAN inválido';
                    /*RegExp testIban = new RegExp(
                        '[A-Z]{2}\d{2} ?\d{4} ?\d{4} ?\d{4} ?\d{4} ?[\d]{0,2}');
                    if (!testIban.hasMatch(value))
                      return 'Preencha um IBAN válido';*/
                    return null;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'IBAN'),
                ),
                DropdownButton(
                  dropdownColor: Colors.white,
                  focusColor: Colors.blue,
                  value: bankCode,
                  //icon: Icon(FontAwesomeIcons.piggyBank),
                  iconSize: 24,
                  elevation: 16,
                  onChanged: (String newValue) {
                    setState(() {
                      bankCode = newValue;
                    });
                  },
                  /*items: <String>['One', 'Two', 'Three']
                      .map<DropdownMenuItem<String>>(
                          (String bank) => DropdownMenuItem<String>(
                                value: bank,
                                child: Text(bank),
                              ))
                      .toList(),*/
                  items: bankList
                      .map<DropdownMenuItem<String>>(
                        (bank) => DropdownMenuItem<String>(
                          value: bank['aspsp-cde'],
                          onTap: () {
                            bankNameSelected = bank['name'];
                            print(bankNameSelected);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Image.network(
                                bank['logoLocation'],
                                height: 45,
                                width: 45,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                width: 250,
                                child: Text(
                                  bank['name'],
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
                RaisedButton(
                  color: Colors.blue,
                  child: Text('Adicionar conta'),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      print(ibanTextEditingController.text);
                      print(bankCode);

                      Future<Response> getAccountWithAspspCode(aspspCode) {
                        Map<String, String> data = {
                          'X-IBM-Client-Id':
                              '31fbd101-ae0c-4ac3-b07f-e067b5bed0a6',
                          'TPP-Transaction-ID': 'a',
                          'TPP-Request-ID': ' asd',
                          'Consent-ID': ' asd',
                          'Signature': ' asd',
                          'TPP-Certificate': ' sad',
                          'Date': 'asd',
                        };

                        dynamic result = get(
                                'https://site1.sibsapimarket.com:8445/sibs/apimarket-sb/$aspspCode/v1-0-2/accounts',
                                headers: data)
                            .then((res) {
                          print(res);
                          print(res.body);
                          Map data = json.decode(res.body);
                          dynamic accounts = data["accountList"];

                          var accountExists = false;
                          var myAccountId = '';
                          for (int i = 0; i < accounts.length; i++) {
                            final accountDetails = accounts[i];
                            final accountIban = accountDetails['iban'];
                            final insertedIban = ibanTextEditingController.text;
                            print(accountIban);

                            if (accountIban == insertedIban) {
                              print('matched IBAN');
                              accountExists = true;
                              myAccountId = accountDetails['id'];
                            }
                          }
                          if (accountExists) {
                            if (accountIdsAdded.contains(myAccountId) ||
                                accountsIds.contains(myAccountId)) {
                              ibanTextEditingController.clear();
                              _scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  content: Text('Conta já existe'),
                                ),
                              );
                            } else {
                              _saveAccount(myAccountId);
                              accountIdsAdded.add(myAccountId);
                              ibanTextEditingController.clear();
                              _scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  content: Text('Conta adicionada'),
                                ),
                              );
                            }
                          } else
                            _scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text('Dados de conta inválidos'),
                              ),
                            );

                          //print(accounts);
                          //print(data);
                        });
                      }

                      getAccountWithAspspCode(bankCode);
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
