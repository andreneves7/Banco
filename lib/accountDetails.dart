import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:bankingApp/radial_painter.dart';
import 'package:bankingApp/routes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'bar_chart.dart';
import 'drawer.dart';
import 'package:http/http.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

class AccountDetails extends StatefulWidget {
  @override
  _AccountDetailsState createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  List accountfirst7Transactions = [];
  String expectedAmount = "0";
  String authorizedAmount = "0";
  bool accountTotalAmountRequested = false;
  bool accountTransactionsRequested = false;
  bool _isLoading = true;
  String accountId = "id";
  String bankCode = "code";
  String bankName = "name";

  final userId = '4sada4564ad65as4d';
  final dbRef = Firestore.instance;
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
      setState(() {
        accountId = userAccounts == null
            ? ''
            : userAccounts.length > 0 ? userAccounts[0].id : '';
        _isLoading = false;
        accounts = userAccounts;
      });
      /*if (userAccounts.length > 0) {
        Navigator.pushReplacementNamed(context, Routes.accountDetails,
            arguments: {'accountId': userAccounts[0], 'accountId': accountId});
      }*/
    });
  }

  _getAccountAmounts(accountUUID, bankAspsCode) {
    if (!accountTotalAmountRequested) {
      accountTotalAmountRequested = true;
      Map<String, String> data = {
        'X-IBM-Client-Id': '31fbd101-ae0c-4ac3-b07f-e067b5bed0a6',
        'TPP-Transaction-ID': 'a',
        'TPP-Request-ID': ' asd',
        'Consent-ID': ' asd',
        'Signature': ' asd',
        'TPP-Certificate': ' sad',
        'Date': 'asd',
      };

      dynamic result = get(
              'https://site1.sibsapimarket.com:8445/sibs/apimarket-sb/$bankAspsCode/v1-0-2/accounts/$accountUUID/balances',
              headers: data)
          .then((res) {
        print(res);
        print(res.body);
        var data = json.decode(res.body.toString());
        String accountExpectedAmount =
            data["balances"][0]["expected"]["amount"]["content"];
        print(accountExpectedAmount);

        String accountAuthorizedAmount =
            data["balances"][0]["authorized"]["amount"]["content"];
        print(accountAuthorizedAmount);

        accountExpectedAmount =
            (double.tryParse(accountExpectedAmount)).toStringAsFixed(2);
        accountAuthorizedAmount =
            (double.tryParse(accountAuthorizedAmount)).toStringAsFixed(2);

        if (expectedAmount != accountExpectedAmount &&
            authorizedAmount != accountAuthorizedAmount) {
          setState(() {
            _isLoading = false;
            expectedAmount = accountExpectedAmount;
            authorizedAmount = accountAuthorizedAmount;
          });
        }
      });
    }
  }

  _getTransactions(accountUUID, bankAspsCode) {
    if (!accountTransactionsRequested) {
      accountTransactionsRequested = true;
      Map<String, String> data = {
        'X-IBM-Client-Id': '31fbd101-ae0c-4ac3-b07f-e067b5bed0a6',
        'TPP-Transaction-ID': 'a',
        'TPP-Request-ID': ' asd',
        'Consent-ID': ' asd',
        'Signature': ' asd',
        'TPP-Certificate': ' sad',
        'Date': 'asd',
      };

      dynamic result = get(
              'https://site1.sibsapimarket.com:8445/sibs/apimarket-sb/$bankAspsCode/v1-0-2/accounts/$accountUUID/transactions',
              headers: data)
          .then((res) {
        print(res);
        print(res.body);
        var data = json.decode(res.body.toString());
        List transactions = data["transactions"]["booked"];
        print(transactions);

        var first7Transactions = [];
        for (int i = 0; i < 7; i++) {
          var amount = (double.tryParse(transactions[i]["amount"]["content"]))
              .toStringAsFixed(2);
          first7Transactions
              .add({'amount': amount, 'date': transactions[i]["bookingDate"]});
        }

        print(first7Transactions);
        if (first7Transactions != accountfirst7Transactions) {
          setState(() {
            accountfirst7Transactions = first7Transactions;
          });
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getMyAccounts();
  }

  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments as Map;
    if (args != null) {
      accountId = args['accountId'];
      bankCode = args['bankCode'];
      bankName = args['bankName'];
      _getAccountAmounts(accountId, bankCode);
      _getTransactions(accountId, bankCode);
    }

    Color getColor(BuildContext context, double percent) {
      if (percent >= 0.50) {
        return Theme.of(context).primaryColor;
      } else if (percent >= 0.25) {
        return Colors.orange;
      }
      return Colors.red;
    }

    Color getTransactionColor(BuildContext context, dynamic costStr) {
      var cost;
      if (costStr is String) {
        cost = double.parse(costStr);
      } else {
        cost = costStr;
      }
      if (cost >= 0) {
        return Colors.green;
      } else {
        return Colors.red;
      }
    }

    Widget _createExpenseCard(name, cost) {
      return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        height: 80.0,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                name,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "$cost€",
                style: TextStyle(
                  color: getTransactionColor(context, cost),
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget _createCard(Widget content) {
      return Container(
        margin: EdgeInsets.all(20.0),
        padding: EdgeInsets.all(20.0),
        height: 75.0,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: content,
      );
    }

    Widget _createAmountDetailsCard(
        {String amountAvailable, String amountAuthorized}) {
      return Container(
        margin: EdgeInsets.all(20.0),
        padding: EdgeInsets.all(20.0),
        height: 92.0,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Column(children: <Widget>[
          Padding(
              padding: EdgeInsets.all(0.0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Saldo Disponivel:',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "$amountAvailable€",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Saldo Autorizado:',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "$amountAuthorized€",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ]),
      );
    }

    Widget _createTransactionsCards() {
      /*return accountfirst7Transactions == null
          ? Container()
          : accountfirst7Transactions.map((transaction) {
              return _createExpenseCard(
                  transaction['date'], transaction['amount']);
            });*/
      return Column(
          children: accountfirst7Transactions.map((transaction) {
        return _createExpenseCard(transaction['date'], transaction['amount']);
      }).toList());
    }

    Widget _createAccountList() {
      return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        height: 80.0,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: DropdownButton(
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
              value: account.id,
              child: Text("Conta $accountIndex"),
            );
          }).toList(),
        ),
      );
    }

    Widget _createTransactionsLabel() {
      return Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 30, 0, 10),
          child: Text(
            'Transações nos últimos 7 dias',
            style: TextStyle(color: Colors.orange, fontSize: 20),
          ),
        ),
      );
    }

    Widget _createPieChart(part, total) {
      final double maxAmount = double.parse(total);
      final double totalAmountSpent = double.parse(part);
      final double amountLeft = maxAmount - totalAmountSpent;
      final double percent = amountLeft / maxAmount;

      return Container(
        margin: EdgeInsets.all(20.0),
        padding: EdgeInsets.all(20.0),
        height: 250.0,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: CustomPaint(
          foregroundPainter: RadialPainter(
            bgColor: Colors.grey[200],
            lineColor: getColor(context, percent),
            percent: percent,
            width: 15.0,
          ),
          child: Center(
            child: Text(
              '${amountLeft.toStringAsFixed(2)}€ / $maxAmount€',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    }

    Widget _createBankNameCard(bankName) {
      return Container(
        child: Center(
          child: Text(
            bankName,
            style: TextStyle(fontSize: 22, color: Colors.black87),
          ),
        ),
        //margin: EdgeInsets.only(left: 30, top: 100, right: 30, bottom: 50),
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        padding: EdgeInsets.all(15),
        //height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
      );
    }

    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Eliminar conta'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Deseja eliminar a conta associada?'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                color: Colors.red,
                child: Text(
                  'Eliminar',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  _removeAccount() async {
                    try {
                      await dbRef
                          .collection('bankAccounts')
                          .document(accountId)
                          .delete();
                    } catch (e) {
                      print(e);
                    }
                  }

                  _removeAccount();
                  Navigator.of(context).pop();
                  Navigator.of(context)
                      .pushReplacementNamed(Routes.selectAccount);
                },
              ),
            ],
          );
        },
      );
    }

    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        /*appBar: AppBar(
          title: Text('Detalhes de conta'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                print('delete');
                _showMyDialog();
              },
            ),
          ],
        ),*/
        //drawer: AppDrawer(),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              forceElevated: true,
              floating: true,
              pinned: true,
              expandedHeight: 120.0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                iconSize: 27.0,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              flexibleSpace: FlexibleSpaceBar(
                title: Text('Detalhes de conta'),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.delete),
                  iconSize: 27.0,
                  onPressed: () {
                    print('delete');
                    _showMyDialog();
                  },
                ),
                /*IconButton(
                  icon: Icon(Icons.add),
                  iconSize: 30.0,
                  onPressed: () {},
                ),*/
              ],
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Center(
                      child: Padding(
                    padding: EdgeInsets.only(top: 75),
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
                  )),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        /*appBar: AppBar(
          title: Text('Detalhes de conta'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                print('delete');
                _showMyDialog();
              },
            ),
          ],
        ),*/
        //drawer: AppDrawer(),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              forceElevated: true,
              floating: false,
              pinned: true,
              expandedHeight: 120.0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                iconSize: 27.0,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              flexibleSpace: FlexibleSpaceBar(
                title: Text('Detalhes de conta'),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.delete),
                  iconSize: 27.0,
                  onPressed: () {
                    print('delete');
                    _showMyDialog();
                  },
                ),
                /*IconButton(
                  icon: Icon(Icons.add),
                  iconSize: 30.0,
                  onPressed: () {},
                ),*/
              ],
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              new Column(
                children: <Widget>[
                  //_createExpenseCard('Saldo Consolidado', totalAmount),
                  //_createAccountList(),
                  _createBankNameCard(bankName),
                  _createAmountDetailsCard(
                      amountAuthorized: authorizedAmount,
                      amountAvailable: expectedAmount),
                  /*
              Container(
                margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 2),
                      blurRadius: 6.0,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: BarChart(expenses),
              ),*/
                  //_createCard(Text('test')),
                  //_createExpenseCard('Carro', 15548.25),
                  //_createPieChart(authorizedAmount, expectedAmount),
                  Divider(),
                  _createTransactionsLabel(),
                  _createTransactionsCards(),
                ],
              ),
            ])),
          ],
        ),
      );
    }
  }
}
