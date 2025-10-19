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
  List _filteredPokemons = [];
  bool loading = true;

  //init state calling fetch pokemon
  @override
  void initState() {
    super.initState();
    fetchPokemons();
  }

  //filter pokemon list with user input
  void filterPokemons(String pokemon){
    setState(() {
      _filteredPokemons = _pokemons.where((e)=> e['name'].toString().startsWith(pokemon)).toList();
    });
    
  }
  //fetch to pokeapi and set state with data
  void fetchPokemons() async {
    List pokemons = [];

    for (var i = 1; i <= 151; i++) {
      final response = await http.get(
        Uri.parse('https://pokeapi.co/api/v2/pokemon/$i'),
      );
      final data = jsonDecode(response.body);
      pokemons.add(data);
    }

    setState(() {
      _pokemons = pokemons;
      _filteredPokemons = _pokemons;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokedex'),
        backgroundColor: Colors.red,
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [ 
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    decoration: InputDecoration(hintText: 'Search for pokemon...', prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                    onChanged: (pokemon){
                      filterPokemons(pokemon);
                    },
                  ),
                ),
                Expanded( //expanded widget to wrap a dynamic widget inside a column
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // number of items in each row
                        mainAxisSpacing: 12.0, // spacing between rows
                        crossAxisSpacing: 12.0, // spacing between columns
                      ),
                      padding: EdgeInsets.all(12.0), // padding around the grid
                      itemCount: _filteredPokemons.length,
                      itemBuilder: (context, index) {
                        final pokemon = _filteredPokemons[index];
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
                ),
              ],
            ),
          ),
    );
  }
}
