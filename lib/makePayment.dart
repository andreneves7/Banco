import 'dart:convert';

import 'package:flutter/material.dart';
import 'drawer.dart';
import 'package:http/http.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MakePayment extends StatefulWidget {
  @override
  _MakePaymentState createState() => _MakePaymentState();
}

class _MakePaymentState extends State<MakePayment> {
  final dbRef = Firestore.instance;
  static final auth = FirebaseAuth.instance;
  String sourceAccountIban = 'iban';
  String paymentType = 'Estado';
  String scheduledType = 'Diario';
  double amount = 0;
  bool isScheduled = false;
  final ibanTextEditingController = TextEditingController();
  final referenceTextEditingController = TextEditingController();
  final amountTextEditingController = TextEditingController();

  static DateTime selectedDate = DateTime.now();
  static DateTime selectedDateFim = DateTime.now();

  final selectedDateTextEditingController =
      TextEditingController(text: "${selectedDate.toLocal()}".split(' ')[0]);
  final selectedDateFimTextEditingController =
      TextEditingController(text: "${selectedDateFim.toLocal()}".split(' ')[0]);

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  static String userId;
  var user = auth.currentUser().then((FirebaseUser user) {
    userId = user.uid;
    print('userId: $userId');
  });
  bool _isLoading = true;
  List<String> accounts;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        helpText: 'Selecione data de Inicio',
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      selectedDateTextEditingController.text =
          "${picked.toLocal()}".split(' ')[0];
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<Null> _selectDateFim(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        helpText: 'Selecione data de Fim',
        context: context,
        initialDate: selectedDateFim,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDateFim) {
      selectedDateFimTextEditingController.text =
          "${picked.toLocal()}".split(' ')[0];
      setState(() {
        selectedDateFim = picked;
      });
    }
  }

  _resetInputs() {
    setState(() {
      sourceAccountIban = accounts.length > 0 ? accounts[0] : '';
      paymentType = 'Estado';
      scheduledType = 'Diario';
      amount = 0;
      isScheduled = false;
      ibanTextEditingController.clear();
      referenceTextEditingController.clear();
      amountTextEditingController.clear();

      selectedDate = DateTime.now();
      selectedDateFim = DateTime.now();

      FocusScope.of(context).requestFocus(new FocusNode());
    });
  }

  _getMyAccounts() async {
    List<String> userAccounts = List();
    dbRef
        .collection('bankAccounts')
        .where('user_id', isEqualTo: userId)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((account) {
        userAccounts.add(account.data['account_iban']);
        //print(account.data);
      });
      //print(userAccounts);

      //var accounts = userAccounts.map((account) => account.account_id);
      print(userAccounts);
      setState(() {
        sourceAccountIban = userAccounts.length > 0 ? userAccounts[0] : '';
        accounts = userAccounts;
        _isLoading = false;
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
    var accountIndex = 0;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Efetuar Pagamentos'),
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
          title: Text('Efetuar Pagamentos'),
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
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'IBAN',
                    ),
                    validator: (value) {
                      if (value.trim().isEmpty) return 'Preencha o IBAN';
                      if (value.trim().length != 25) return 'IBAN inválido';
                      return null;
                    },
                  ),
                  DropdownButton(
                    hint: Text('Contas'),
                    dropdownColor: Colors.white,
                    focusColor: Colors.blue,
                    value: sourceAccountIban,
                    //icon: Icon(FontAwesomeIcons.piggyBank),
                    iconSize: 24,
                    elevation: 16,
                    onChanged: (String newValue) {
                      print(newValue);
                      setState(() {
                        sourceAccountIban = newValue;
                      });
                    },
                    items: accounts.map<DropdownMenuItem<String>>((accountId) {
                      accountIndex++;
                      return DropdownMenuItem<String>(
                        value: accountId,
                        child: Text("Conta $accountIndex"),
                      );
                    }).toList(),
                  ),
                  DropdownButton(
                    hint: Text('Tipo de pagamento'),
                    dropdownColor: Colors.white,
                    focusColor: Colors.blue,
                    value: paymentType,
                    //icon: Icon(FontAwesomeIcons.piggyBank),
                    iconSize: 24,
                    elevation: 16,
                    onChanged: (String newValue) {
                      setState(() {
                        paymentType = newValue;
                      });
                    },
                    items: <String>['Estado', 'Comunicações', 'Entidades']
                        .map<DropdownMenuItem<String>>(
                            (String paymentType) => DropdownMenuItem<String>(
                                  value: paymentType,
                                  child: Text(paymentType),
                                ))
                        .toList(),
                  ),
                  TextFormField(
                    controller: referenceTextEditingController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Referencia',
                    ),
                    validator: (value) {
                      if (value.isEmpty) return 'Preencha a Referencia';
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    controller: amountTextEditingController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Montante',
                    ),
                    validator: (value) {
                      if (double.tryParse(value) == null) {
                        return 'Montante inválido';
                      } else if (value.isEmpty) return 'Preencha o Montante';
                      return null;
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Pagamento Agendado'),
                    value: isScheduled,
                    onChanged: (newValue) {
                      setState(() {
                        isScheduled = newValue;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  TextFormField(
                    controller: selectedDateTextEditingController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Data inicio',
                    ),
                    onTap: () {
                      _selectDate(context);
                    },
                    readOnly: true,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    controller: selectedDateFimTextEditingController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Data fim',
                    ),
                    onTap: () {
                      _selectDateFim(context);
                    },
                    readOnly: true,
                  ),
                  DropdownButton(
                    hint: Text('Tipo de agendamento'),
                    dropdownColor: Colors.white,
                    focusColor: Colors.blue,
                    value: scheduledType,
                    //icon: Icon(FontAwesomeIcons.piggyBank),
                    iconSize: 24,
                    elevation: 16,
                    onChanged: (String newValue) {
                      setState(() {
                        scheduledType = newValue;
                      });
                    },
                    items: <String>[
                      'Diario',
                      'Semanal',
                      'Mensal',
                      'A cada duas semanas',
                    ]
                        .map<DropdownMenuItem<String>>(
                            (String scheduledType) => DropdownMenuItem<String>(
                                  value: scheduledType,
                                  child: Text(scheduledType),
                                ))
                        .toList(),
                  ),
                  RaisedButton(
                    color: Colors.blue,
                    child: Text('Efetuar pagamento'),
                    onPressed: () {
                      Future<Response> makePayment(jsonData) {
                        Map<String, String> data = {
                          'X-IBM-Client-Id':
                              '31fbd101-ae0c-4ac3-b07f-e067b5bed0a6',
                          'accept': 'application/json',
                          'tpp-transaction-id':
                              'ceae5ddb2325457bac80b43baefaf558',
                          'tpp-request-id': 'bcd4aad6fcc246419485a015f4cb6996',
                          'content-type': 'application/json',
                          'psu-id': 'asd',
                          'psu-id-type': 'asd',
                          'psu-corporate-id': 'asd',
                          'psu-corporate-id-type': 'asdad',
                          'psu-consent-id': 'asdad',
                          'psu-agent': 'asda',
                          'psu-ip-address': '1',
                          'psu-geo-location': 'asdad',
                          'tpp-redirect-uri': 'asda',
                          'signature': '1',
                          'digest': '1',
                          'tpp-certificate': '71525dacac1763b812af4e83af61853',
                          'Date': '2020-03-31',
                        };

                        /*const jsonData = {
                          "endToEndIdentification": "",
                          "debtorAccount": {
                            "iban": "PT5020000",
                            "currency": "EUR"
                          },
                          "instructedAmount": {
                            "currency": "EUR",
                            "content": "400"
                          },
                          "creditorAccount": {
                            "iban": "PT0003000",
                            "currency": "EUR"
                          },
                          "creditorAgent": "ABCDEFABC0A",
                          "creditorName": "Vitor Vilas Boas",
                          "creditorAddress": {
                            "street": "Rua desce e dosce",
                            "buildingNumber": "207",
                            "city": "Porto",
                            "postalCode": "4350-999",
                            "country": "Portugal"
                          },
                          "remittanceInformationUnstructured": ""
                        };*/

                        post(
                          'https://site1.sibsapimarket.com:8445/sibs/apimarket-sb/ABPT/v1-0-2/payments/sepa-credit-transfers?tppRedirectPreferred=false',
                          headers: data,
                          body: json.encode(jsonData),
                        ).then((res) {
                          var result = res;
                          var body = res.body;
                          print(body);
                          Map data = json.decode(res.body);
                          dynamic paymentSucceed =
                              data["transactionFeeIndicator"];
                          print(paymentSucceed);

                          //print(res.statusCode);
                          if (paymentSucceed && res.statusCode == 201) {
                            _resetInputs();
                            _scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text('Pagamento efetuado com sucesso'),
                              ),
                            );
                          } else {
                            _scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text('Erro ao efetuar o pagamento'),
                              ),
                            );
                          }
                        });
                      }

                      if (accounts.length == 0) {
                        _scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            content: Text('Sem contas registadas'),
                          ),
                        );
                      } else if (sourceAccountIban ==
                          ibanTextEditingController.text) {
                        _scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            content:
                                Text('2 IBAN\'s correspondem à mesma conta'),
                          ),
                        );
                      } else {
                        if (_formKey.currentState.validate()) {
                          print('Make payment...');

                          print(ibanTextEditingController.text);
                          print(sourceAccountIban);
                          print(paymentType);
                          print(referenceTextEditingController.text);
                          print(amountTextEditingController.text);

                          print(isScheduled);
                          print(selectedDate);
                          print(selectedDateFim);
                          print(scheduledType);

                          var amount = amountTextEditingController.text;
                          //var reference = referenceTextEditingController.text;
                          var debtorAccount = ibanTextEditingController.text;

                          var jsonData = {
                            "endToEndIdentification": "",
                            "debtorAccount": {
                              "iban": sourceAccountIban,
                              "currency": "EUR"
                            },
                            "instructedAmount": {
                              "currency": "EUR",
                              "content": amount
                            },
                            "creditorAccount": {
                              "iban": debtorAccount,
                              "currency": "EUR"
                            },
                            "creditorAgent": "ABCDEFABC0A",
                            "creditorName": "Quim Barroso",
                            "creditorAddress": {
                              "street": "Rua Padre Vilas Boas",
                              "buildingNumber": "207",
                              "city": "Porto",
                              "postalCode": "4350-999",
                              "country": "Portugal"
                            },
                            "remittanceInformationUnstructured": ""
                          };
                          makePayment(jsonData);
                        }
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
}
