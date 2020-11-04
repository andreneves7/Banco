import 'dart:convert';

import 'package:bankingApp/routes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';

import 'drawer.dart';
import 'package:http/http.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Account {
  final String id;
  final String bank_code;
  final String bank_name;

  Account({this.id, this.bank_code, this.bank_name});

  @override
  String toString() {
    return '$id $bank_code $bank_name';
  }
}

class SelectAccount extends StatefulWidget {
  @override
  _SelectAccountState createState() => _SelectAccountState();
}

class _SelectAccountState extends State<SelectAccount> {
  final dbRef = Firestore.instance;
  static final auth = FirebaseAuth.instance;
  List accountfirst7Transactions = [];
  String totalAmount = "0";
  bool accountTotalAmountRequested = false;
  bool accountTransactionsRequested = false;
  bool _isLoading = true;
  String accountId = "id";
  String accountsTotalBalance = '';

  static String userId;
  var user = auth.currentUser().then((FirebaseUser user) {
    print('userId: $userId');
  });

  List<Account> accounts;
  var accountIndex = 0;

  _getMyAccounts() async {
    List<Account> userAccounts = List();
    dbRef
        .collection('bankAccounts')
        .where('user_id', isEqualTo: userId)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((account) {
        userAccounts.add(
          Account(
            id: account.data['account_id'],
            bank_code: account.data['bank_code'],
            bank_name: account.data['bank_name'],
          ),
        );
        //print(account.data);
      });
      print(userAccounts);

      //var accounts = userAccounts.map((account) => account.account_id);
      print(userAccounts);
      setState(() {
        accountId = userAccounts.length > 0 ? userAccounts[0].id : '';
        accounts = userAccounts;
      });
      if (userAccounts.length == 0) {
        setState(() {
          _isLoading = false;
        });
      } else {
        getTotalBalanceAllAccounts();
      }
      /*if (userAccounts.length > 0) {
        Navigator.pushReplacementNamed(context, Routes.accountDetails,
            arguments: {'accountId': userAccounts[0], 'accountId': accountId});
      }*/
    });
  }

  getTotalBalanceAllAccounts() {
    var total = 0.0;
    List<double> amounts = List();
    accounts.forEach((account) {
      var accountExpectedAmount = null;
      Map<String, String> data = {
        'X-IBM-Client-Id': '31fbd101-ae0c-4ac3-b07f-e067b5bed0a6',
        'TPP-Transaction-ID': 'a',
        'TPP-Request-ID': ' asd',
        'Consent-ID': ' asd',
        'Signature': ' asd',
        'TPP-Certificate': ' sad',
        'Date': 'asd',
      };

      get('https://site1.sibsapimarket.com:8445/sibs/apimarket-sb/${account.bank_code}/v1-0-2/accounts/${account.id}/balances',
              headers: data)
          .then((response) {
        print(response.body);
        var data = json.decode(response.body.toString());
        accountExpectedAmount =
            data["balances"][0]["expected"]["amount"]["content"];
        print(accountExpectedAmount);
        amounts.add(double.tryParse(accountExpectedAmount));
        if (accounts.length == amounts.length) {
          total = amounts.reduce((a, b) => a + b);
          setState(() {
            accountsTotalBalance = total.toStringAsFixed(2); //total.toString()
            _isLoading = false;
          });
        }
      });
    });
  }

  Widget _createAccountList() {
    return Column(
      //mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Card(
          elevation: 4,
          child: ListTile(
              title: Center(
            child: Text(
              'Saldo consolidado: ${accountsTotalBalance}€',
            ),
          )),
        ),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: accounts.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('Conta ${index + 1} - ${accounts[index].bank_name}'),
              onTap: () {
                print('Account selected $index');
                var accountId = accounts[index].id;
                var accountBankCode = accounts[index].bank_code;
                var accountBankName = accounts[index].bank_name;

                Navigator.pushNamed(context, Routes.accountDetails, arguments: {
                  'accountId': accountId,
                  'bankCode': accountBankCode,
                  'bankName': accountBankName,
                });
                print(accountId);
                print(accountBankCode);
              },
            );
          },
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _getMyAccounts();
  }

  @override
  Widget build(BuildContext context) {
    bool _enabled = true;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Selecionar conta'),
        ),
        drawer: AppDrawer(),
        body: SingleChildScrollView(
          //width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Card(
                elevation: 4,
                child: ListTile(
                  title: Center(
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100],
                      enabled: _enabled,
                      child: Container(
                        width: 225,
                        height: 13.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: SizedBox(
                  height: 250,
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
                    enabled: _enabled,
                    child: ListView.builder(
                      itemBuilder: (_, __) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: double.infinity,
                                    height: 17.0,
                                    color: Colors.white,
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.0),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      itemCount: 6,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
      /*Center(
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
      );*/
    } else if (accounts.length == 0) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Selecionar conta'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, Routes.addAccount);
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
        ),
        drawer: AppDrawer(),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                FontAwesomeIcons.exclamationTriangle,
                size: 29,
                color: Colors.orange,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Sem contas registadas',
                style: TextStyle(fontSize: 17),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Selecionar conta'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, Routes.addAccount);
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
        ),
        drawer: AppDrawer(),
        body: SingleChildScrollView(
          child: _createAccountList(),
        ),
      );
    }
  }
}
