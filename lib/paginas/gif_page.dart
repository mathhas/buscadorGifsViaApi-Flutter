import 'package:flutter/material.dart';
import 'package:share/share.dart';

class GifPage extends StatelessWidget {
  //Atributos
  final Map _dadosDoGif; //dados do gif selecionado na home_page

  //métodos
  //construtor
  GifPage(this._dadosDoGif);

  //contrutor da interface da pagina do gif selecionado
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Scaffold permite a criação da appBar nativa
      appBar: AppBar(
        title: Image.network(
            "https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif"),
        backgroundColor: Colors.white12,
        //Criação do botão de compartilhar gif e sua funcionalidade
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              Share.share(
                _dadosDoGif["images"]["fixed_height"]["url"],
              );
            },
          )
        ],
      ),
      //Construção do corpo do app
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.fromLTRB(0.0, 180.0, 0.0, 0.0),
              //o gif escolhido
              child: Center(
                child:
                    Image.network(_dadosDoGif["images"]["fixed_height"]["url"]),
              )),
          Padding(padding: EdgeInsets.all(10.0)),
          //O título do gif escolhido abaixo dele
          Text(
            _dadosDoGif["title"],
            style: TextStyle(color: Colors.white30, fontSize: 18.0),
          ),
        ],
      ),
    );
  }
}
