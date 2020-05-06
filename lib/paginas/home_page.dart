import 'dart:convert';
import 'package:buscador_gifs/paginas/gif_page.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // url para busca dos melhores gifs: https://api.giphy.com/v1/gifs/trending?api_key=u7Q66HeOtgx2glluzY72NAk9RFWpngd0&limit=20&rating=G
  // url para buscas de gifs através de pesquisas por tema: https://api.giphy.com/v1/gifs/search?api_key=u7Q66HeOtgx2glluzY72NAk9RFWpngd0&q=StringDasPesqusias&limit=25&offset=0&rating=G&lang=en

  String _pesquisa; // armazena o que digitar para pesquisar no textField
  int _offSet =
      0; // o offSet é usado quando o usuário quiser ver mais gifs, ele atribui quantos gifs pular, e a api do site pula essa quantidade e apresenta novos gifs

  //requisição dos dados (gif) da api (retorna um map no futuro (pois envolve requisição da api))
  Future<Map> _getGifs() async {
    http.Response resposta;

    if (_pesquisa == null || _pesquisa.isEmpty) {
      //se a busca não envolver pesquisa retorna url dos melhores sem possibilidade de carregar mais, apenas os trading 20
      resposta = await http.get(
          "https://api.giphy.com/v1/gifs/trending?api_key=u7Q66HeOtgx2glluzY72NAk9RFWpngd0&limit=20&rating=G");
    } else {
      //se o textField de pesquisa estiver com algo, retorna gifs relacionados a pesquisa
      resposta = await http.get(
          "https://api.giphy.com/v1/gifs/search?api_key=u7Q66HeOtgx2glluzY72NAk9RFWpngd0&q=$_pesquisa&limit=25&offset=$_offSet&rating=G&lang=en");
    }

    //retorna os dados do formato json vindos da page, em um map
    return json.decode(resposta.body);
  }

  //--debuga mostrando os dados que _getGifs retorna
  // @override
  // void initState() {
  //   super.initState();

  //   _getGifs().then((map) {
  //     print(map);
  //   });
  // }

  //constroi interface
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //constroi appBar nativa
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            "https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif"),
        centerTitle: true,
      ),
      //corpo da pagina que vai ter o textField de pesquisa e a grade de gifs
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            //espaçamento padrão no app para margens em todas laterais
            padding: EdgeInsets.all(10.0),
            //----------------------------------widget de pesquista de gifs
            child: TextField(
              decoration: InputDecoration(
                labelText: "Pesquise por Tema",
                labelStyle: TextStyle(color: Colors.white, fontSize: 18.0),
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center,
              onSubmitted: (text) {
                setState(() {
                  _pesquisa = text;
                  _offSet =
                      0; // zera o offSet para fazer nova pesquisa e mostrar os primeiros gifs novamente
                });
              },
            ),
          ),
          //---------------------------------------lista de gifs
          Expanded(
            //expande a coluna para o conteúdo se espalhar por todo widget
            child: FutureBuilder(
              future:
                  _getGifs(), //no futuro (após a requisiçãoe retorno da api), recebe os dados
              builder: (context, snaptshot) {
                //constroi uma animação de "carregando" até receber os dados da api nos casos "1" e "2"
                switch (snaptshot.connectionState) {
                  case ConnectionState.waiting: //"1"
                  case ConnectionState.none: //"2"
                    return Container(
                      width: 200.0,
                      height: 200.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5.0,
                      ),
                    );
                  default: // Quando a api já tiver retornado...
                    if (snaptshot.hasError) {
                      //se tiver erro...
                      return Container(
                        child: Text(
                          "Ocorreu algum erro, recarregue o App",
                          textAlign: TextAlign.center,
                        ),
                      );
                    } else {
                      //Se os dados não tiverem erro exibe a lista de gifs chamando o widget que a constroi
                      return _criaExibeListaGifs(context, snaptshot);
                    }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  int _tamanhoListaGifs(List data) {
    if (_pesquisa == null || _pesquisa == "") {
      return data.length;
    } else {
      return ((data.length) + (1));
    }
  }

  Widget _criaExibeListaGifs(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        padding: EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // quantidade de itens no eixo X
            crossAxisSpacing:
                10.0, // espaçamento entre os itens da gridList no eixo X
            mainAxisSpacing:
                10.0), // espaçamento entre os itens da gridList no eixo X
        itemCount: _tamanhoListaGifs(snapshot.data["data"]),
        //constroi os itens a vizualizar
        itemBuilder: (context, index) {
          //--------------------------constroi gif a gif até o tamanho Desejado, tanto dos trading ou pesquisa
          if (_pesquisa == null ||
              _pesquisa.isEmpty ||
              index < snapshot.data["data"].length) {
            return GestureDetector(
              //para que as imagens apareção suavemente usa-se fadeInImage...
              child: FadeInImage.memoryNetwork(
                placeholder:
                    kTransparentImage, //aparece antes uma suave imagem transparente, depois, com delay, o gif.
                image: snapshot.data["data"][index]["images"]["fixed_height"]
                    ["url"],
                height: 200.0,
                width: 263.0,
                fit: BoxFit.cover,
              ),
              //direciona para a página gif-page caso clicke no determinado gif
              onTap: () {
                //vai para a _gifPage com o contexto atual e a rota da pagina
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GifPage(snapshot.data["data"][index]),
                  ),
                );
              },
              // se segurar o gif...
              onLongPress: () {
                //compartilha a url
                Share.share(snapshot.data["data"][index]["images"]
                    ["fixed_height"]["url"]);
              },
            );
          } else {
            //---------------------------------------constroi a opção de buscar mais gifs para o caso de pesquisa
            return Container(
              //para atender a interação do usuário...
              child: GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    //icone "+"
                    Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 70.0,
                    ),
                    //com o texto...
                    Text(
                      "Carregar Mais Gifs",
                      style: TextStyle(color: Colors.white, fontSize: 22.0),
                    )
                  ],
                ),
                //caso toque no "botão" o offSet coma a quantidade de gis acima, para pular eles e buscar os proximos 19
                onTap: () {
                  setState(() {
                    _offSet += 19;
                  });
                },
              ),
            );
          }
        });
  }
}
