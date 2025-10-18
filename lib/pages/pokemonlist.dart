import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PokemonList extends StatefulWidget {
  const PokemonList({super.key});

  @override
  State<PokemonList> createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {

  List _pokemons = [];

  @override
  void initState() {
    super.initState();
    fetchPokemons();
  }

  void fetchPokemons() async{
    List pokemons = [];

    for (var i = 1; i <= 10; i++) {
      final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$i'));
      final data = jsonDecode(response.body);
      print(data['name']);
      pokemons.add(data);
      
    }
     setState(() {
        _pokemons = pokemons;
      });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: ListView.builder(
        itemCount: _pokemons.length,
        itemBuilder: (context, index){
          final pokemon = _pokemons[index];
          return Container(
            child: Column(
              children: [Image.network(pokemon['sprites']['front_default']),
              Text(pokemon['name'])],
            ),
          );
      }),
    );
  }
}