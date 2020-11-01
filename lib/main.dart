import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consultar Cotações',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Cotações'),
        ),
        body: CotacaoWidget()));
  }
}


class CotacaoWidget extends StatefulWidget {  // classe que gerencia a criação do objeto
 @override
 _CotacaoWidgetState createState() => _CotacaoWidgetState(); // singleton - cira uma única instância
}

class _CotacaoWidgetState extends State<CotacaoWidget> {
  List<dynamic> _moedas = List<dynamic>();

  String _moedaSelecionada = 'Todas';
  var _moedasSelect =['Todas','USD','EUR','BTC'];

  @override
  Widget build(BuildContext context)  {
    return Column(children: [
      DropdownButton(
        value: _moedaSelecionada,
        items: _moedasSelect.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String newValue) {
          setState(() {
            _moedaSelecionada = newValue;
          });
        },
      ),
      Container(
        margin: EdgeInsets.all(10),
        child: RaisedButton(
                onPressed: onButtonPressCotacao,
                child: const Text('Consultar', style: TextStyle(fontSize: 20)),
              ),),
      Expanded(
        child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: _moedas.length,
                itemBuilder: (context, i){
                  return Container(
                    height: 50,
                    padding: EdgeInsets.all(10),
                    child: Text(_moedas[i]["name"]+" - Alta:"+_moedas[i]["high"]+" - Baixa:"+_moedas[i]["low"]),
                  );
                },
              ),
            )
    ],);
 }

  onButtonPressCotacao() async {
    if(_moedaSelecionada == "Todas"){
      // Realizando Request
      String url = 'https://economia.awesomeapi.com.br/json/all';
      Response response = await get(url);
      // Capturando Response
      String content = response.body;
      if (response.statusCode == 200) {
        print('Response body : $content');
        try {
          final parsed = jsonDecode(content).cast<String, dynamic>();
          setState(() { // quando precisa alterar o estado de um compoenente, precisa do setState
            _moedas.clear();
            print(parsed);
            parsed.keys.forEach((item){
                _moedas.add(parsed[item]);
            });
          });
        } catch (Ex) {
          print("Erro ao decodificar JSON : $Ex");
        }
      }
    }else{
      String url = 'https://economia.awesomeapi.com.br/json/${_moedaSelecionada}';
      Response response = await get(url);
      // Capturando Response
      String content = response.body;
      if (response.statusCode == 200) {
        print('Response body : $content');
        try {
          final parsed = jsonDecode(content)[0].cast<String, dynamic>();
          setState(() { // quando precisa alterar o estado de um compoenente, precisa do setState
            _moedas.clear();
            print(parsed);
            _moedas.add(parsed);
          });
        } catch (Ex) {
          print("Erro ao decodificar JSON : $Ex");
        }
      }
    }
  }
}