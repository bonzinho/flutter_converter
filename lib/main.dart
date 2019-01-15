import 'package:flutter/material.dart';

import "package:http/http.dart" as http;
import 'dart:async'; // Para não ficar a aguardar as requisições -> requisiçõesa asincronas
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&key=2c31cd4a";

void main() async {
  runApp(MaterialApp(
      home: Home()
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Conversos \$"),
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
                    Container(color: Colors.green);
                  }
            } // Estado da conexão
          }) // Futurebuilder para carregar os dados
    );
  }
}
