import 'package:flutter/material.dart';

import "package:http/http.dart" as http;
import 'dart:async'; // Para não ficar a aguardar as requisições -> requisiçõesa asincronas
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&key=2c31cd4a";

void main() async {
  runApp(MaterialApp(
      home: Home(),
    theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.white,
    ),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request); // retorna dados no futuro;
  return json.decode(response.body); // Pega os dados do JSON;
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // final porque não mudam
  final realController = TextEditingController();
  final dollarController = TextEditingController();
  final euroController = TextEditingController();
  final bitController = TextEditingController();

  // Valor em real
  double dollar;
  double euro;

  double bit; // Valor em usd


  void _bitChanged(String text){
    double bit = double.parse(text);

  }

  void _realChanged(String text){
    double real = double.parse(text);
    dollarController.text = (real/dollar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text){
    double dollar = double.parse(text);
    realController.text = (dollar * this.dollar).toStringAsFixed(2);
    euroController.text = (dollar * this.dollar / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text){
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dollarController.text = (euro * this.euro / dollar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Conversor de Moeda \$"),
        backgroundColor: Colors.amber,
      ),
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text("Aguarde...",
                      style: TextStyle(
                          color: Colors.amber,
                          fontSize: 25.0),
                      textAlign: TextAlign.center,
                  )
                );
                default:
                  if(snapshot.hasError){
                    return Center(
                      child: Text("Erro ao carregar os dados!",
                          style: TextStyle(color: Colors.amber, fontSize: 25),
                          textAlign: TextAlign.center),
                    );
                  }else{
                    dollar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                    euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                    bit = snapshot.data["results"]["bitcoin"]["buy"]; // valor em dollars
                    return SingleChildScrollView(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[

                          Icon(Icons.monetization_on, size: 150, color: Colors.amber),
                          buildTextField('BitCoin', 'B', bitController, _bitChanged),
                          Divider(),
                          buildTextField('Euro', '€', euroController, _euroChanged),
                          Divider(),
                          buildTextField('Dollars Americanos', 'US\$', dollarController, _dollarChanged),
                          Divider(),
                          buildTextField('Reais', 'R\$', realController, _realChanged),
                          Divider(),
                        ],
                      )
                    );
                  }
            } // Estado da conexão
          }) // Futurebuilder para carregar os dados
    );
  }
}

// Função para criar campos de texto, para não repetir código
Widget buildTextField(String label, String prefix, TextEditingController c, Function f){
  return TextField(
    controller: c,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder(),
        prefixText: prefix
    ),
    style: TextStyle(
      color: Colors.amber, fontSize: 25,
    ),
    onChanged: f,
    keyboardType: TextInputType.number,
  );
}
