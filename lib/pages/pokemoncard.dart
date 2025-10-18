import 'package:flutter/material.dart';

class PokemonCard extends StatelessWidget {
  const PokemonCard({super.key, required this.pokemon});
  final pokemon;

  @override
  Widget build(BuildContext context) {
    List types = [];
    (pokemon['types'] as List).forEach((t) {
      types.add(t['type']['name']);
    });

    String typeString = types.join(', ');

    return Card(
      elevation: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(pokemon['sprites']['front_default']),
                  Image.network(pokemon['sprites']['back_default'])
                ],
              ),
              Text('Name: ${pokemon['name']}'),
              Text('Number: ${pokemon['id']}'),
              Text('Type: $typeString'),
              Text('Height: ${pokemon['height'] / 10} m'),
              Text('Weight: ${pokemon['weight'] / 10} kg'),
            ],
          ),
      );
  }
}
