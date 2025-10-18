import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './pokemoncard.dart';

class PokemonList extends StatefulWidget {
  const PokemonList({super.key});

  @override
  State<PokemonList> createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  List _pokemons = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchPokemons();
  }

  void fetchPokemons() async {
    List pokemons = [];

    for (var i = 1; i <= 151; i++) {
      final response = await http.get(
        Uri.parse('https://pokeapi.co/api/v2/pokemon/$i'),
      );
      final data = jsonDecode(response.body);
      print(data['name']);
      pokemons.add(data);
    }
    setState(() {
      _pokemons = pokemons;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // number of items in each row
                mainAxisSpacing: 12.0, // spacing between rows
                crossAxisSpacing: 12.0, // spacing between columns
              ),
              padding: EdgeInsets.all(12.0), // padding around the grid
              itemCount: _pokemons.length,
              itemBuilder: (context, index) {
                final pokemon = _pokemons[index];
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => PokemonCard(pokemon: pokemon,),
                      ),
                    );
                  },

                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.fromBorderSide(
                        BorderSide(color: Colors.black),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: const Color.fromARGB(255, 255, 164, 162),
                    ),
                  
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(pokemon['sprites']['front_default']),
                          Text(pokemon['name']),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
