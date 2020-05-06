import 'package:buscador_gifs/paginas/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  //constroi o material app
  runApp(MaterialApp(
    //e chama a pagina inicial
    home: HomePage(),
    // tema para que as bordas de textField fiquem brancas
    theme: ThemeData(
        hintColor: Colors.white,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          hintStyle: TextStyle(color: Colors.white),
        )),
  ));
}
