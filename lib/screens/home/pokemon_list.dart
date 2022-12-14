import 'package:flutter/material.dart';
import 'package:pokemon_app/widgets/no_results.dart';
import 'package:pokemon_app/screens/home/pokemon_item.dart';
import 'package:pokemon_app/model/pokemon.dart';

class PokemonList extends StatelessWidget {
  const PokemonList({Key? key, required this.pokemon}) : super(key: key);

  final Pokemon pokemon;

  static double mainAxisSpacing = 2;
  static double crossAxisSpacing = 2;
  static double childAspectRatio = 1.25;
  static int crossAxisCount = 2;

  @override
  Widget build(BuildContext context) {
    if (pokemon.results.isEmpty) {
      return const NoResults(
          description: 'No pokémon found matching your search.');
    }

    return GridView.count(
      padding: const EdgeInsets.all(12),
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      childAspectRatio: childAspectRatio,
      children: pokemon.results
          .map((pokemon) => PokemonItem(pokemon: pokemon))
          .toList(),
    );
  }
}
