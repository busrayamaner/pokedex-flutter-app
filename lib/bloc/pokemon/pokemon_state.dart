part of 'pokemon_bloc.dart';

@immutable
abstract class PokemonState {
  const PokemonState();
}

class PokemonInitial extends PokemonState {
  const PokemonInitial();
}

class PokemonLoading extends PokemonState {
  const PokemonLoading();
}

class PokemonLoaded extends PokemonState {
  final Pokemon pokemonList;

  const PokemonLoaded(this.pokemonList);
}

class PokemonDetailLoaded extends PokemonState {
  final PokemonDetails pokemonDetail;

  const PokemonDetailLoaded(this.pokemonDetail);
}

class PokemonFavouritesLoaded extends PokemonState {
  final List<Result> pokemonFavouritesList;

  const PokemonFavouritesLoaded(this.pokemonFavouritesList);
}

class PokemonError extends PokemonState {
  final String message;
  const PokemonError(this.message);
}
