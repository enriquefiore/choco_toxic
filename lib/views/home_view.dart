import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:chocotoxic/views/menu_view.dart';

class HomeView extends StatefulWidget {
  static const String routeName = '/';
  HomeView({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var pesoChoController = TextEditingController();
  var pesoDogController = TextEditingController();
  String ddChocolateValue = "Ao leite";
  String _resultadoCalculadora = "";
  String _resultadoMensagem = "";
  Color _resultadoCor = Colors.grey[50];
  Color _resultadoCorFonte = Colors.white;

  void _resetForm() {
    setState(() {
      ddChocolateValue = "";
      pesoChoController.text = "";
      pesoDogController.text = "";
      _resultadoCalculadora = "";
      _resultadoMensagem = "";
      _resultadoCor = Colors.grey[50];
      _resultadoCorFonte = Colors.white;
    });
  }

  BorderRadiusGeometry toggleBorder(){
    return _resultadoMensagem != '' ? BorderRadius.only(
      bottomLeft: Radius.circular(10),
      bottomRight: Radius.circular(10),
      topLeft: Radius.circular(10),
      topRight: Radius.circular(10)
    ) : BorderRadius.zero;
  }

  BoxShadow toggleShadow(){
    return _resultadoMensagem != ''? BoxShadow(
      color: Colors.grey.withOpacity(0.5),
      spreadRadius: 5,
      blurRadius: 7,
      offset: Offset(0, 3),
    ) : BoxShadow(color:Colors.grey[50]);
  }

  BoxShadow toggleBtnShadow(){
    return BoxShadow(
      color: Colors.grey.withOpacity(0.5),
      spreadRadius: 3,
      blurRadius: 10,
      offset: Offset(0, 3),
    );
  }

  void calcular(){
    setState(() {
      double chocolate = double.tryParse(pesoChoController.text);
      double cachorro = double.tryParse(pesoDogController.text);
      double metilxantina = 0;
      double resultado = 0;

      switch(ddChocolateValue){
        case "Branco":
          metilxantina = 0.0035;
          break; 
        case "Ao leite":
          metilxantina = 2.2575;
          break;
        case "Achocolatado":
          metilxantina = 5.3264;
          break;
        case "Meio amargo":
          metilxantina = 5.6438;
          break;
        case "Amargo":
          metilxantina = 15.3442;
          break;
        case "Cacau em pó":
          metilxantina = 28.4661;
          break;
      }

      if(cachorro != null && chocolate != null) {
        resultado = (metilxantina * chocolate) / cachorro;
        _resultadoCalculadora = "${resultado.toStringAsFixed(2)} mg/kg";
        _resultadoCor = resultado < 20 ? Colors.teal : resultado < 40 ? Colors.yellow : resultado < 60 ? Colors.orange : Colors.red;
        _resultadoCorFonte = resultado < 20  || resultado >= 60 ? Colors.white : Colors.black;  
        _resultadoMensagem = resultado < 20 ? 'Baixo risco' : resultado < 40 ? 'Médio risco' : resultado < 60 ? 'Alto risco' : 'Risco de morte';
      } else
        _resultadoCalculadora = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: MenuView(),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 100,
              ),
              Focus(
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Peso do cão (kg)",
                      labelStyle: TextStyle(
                          color: Colors.brown,                          
                      )
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.brown,
                    fontSize: 20.0,
                  ),
                  controller: pesoDogController,
                  validator: (value) {
                    if(value.isEmpty)
                      return "Insira o peso em kilogramas";
                  },
                ),
              ),
              Focus(
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                      labelText: "Tipo de chocolate",
                      labelStyle: TextStyle(
                          color: Colors.brown,
                          fontSize: 20.0
                      )
                  ),
                  items: <String>['Ao leite','Meio amargo','Amargo','Achocolatado','Cacau em pó','Branco']
                  .map<DropdownMenuItem<String>>((String value1){
                    return DropdownMenuItem<String>(
                      value: value1,
                      child: Text(value1),
                    );
                  }).toList(),
                  style:TextStyle(
                    color: Colors.brown,
                    fontSize: 20.0,
                  ),
                  onChanged: (String newValue){
                    setState((){
                      ddChocolateValue = newValue;
                    });
                  }
                ),
              ),
              Focus(
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Quantidade de chocolate (g)",
                      labelStyle: TextStyle(
                          color: Colors.brown
                      )
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.brown,
                    fontSize: 20.0,
                  ),
                  controller: pesoChoController,
                  validator: (value) {
                    if(value.isEmpty)
                      return "Insira o peso em gramas";
                    /* else
                      calcular(); */
                  },
                ),
                /* onFocusChange: (hasFocus){
                  if(!hasFocus)
                    calcular();
                }, */
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [ toggleBtnShadow() ],
                  ),
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    color: Colors.teal,
                    child: Text(
                      'CALCULAR',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[50],
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold
                      ), 
                    ),
                    onPressed: (){
                      calcular();
                    },
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: _resultadoCor,
                  borderRadius: toggleBorder(),
                  boxShadow: [ toggleShadow() ],
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      _resultadoMensagem,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: _resultadoCorFonte,
                          fontSize: 40.0
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      _resultadoCalculadora,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: _resultadoCorFonte,
                          fontSize: 20.0
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _resetForm,
        autofocus: ddChocolateValue.contains('leite'),
        tooltip: 'Recomeçar',
        child: Transform(
          alignment: Alignment.center,
          child: Icon(Icons.refresh),
          transform: Matrix4.rotationY(math.pi),
        ),
        backgroundColor: Colors.brown,
      ),
    );
  }
}