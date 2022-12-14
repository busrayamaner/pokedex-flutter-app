part of 'pokemon_bloc.dart';

@immutable
abstract class PokemonEvent {
  const PokemonEvent();
}

class GetPokemons extends PokemonEvent {
  const GetPokemons();
}

class FilterPokemons extends PokemonEvent {
  final String filterText;

  const FilterPokemons(this.filterText);
}

class FavoritePokemons extends PokemonEvent {
  final List<Result> favoritePokemons;

  const FavoritePokemons(this.favoritePokemons);
}

class GetPokemonDetail extends PokemonEvent {
  final String url;

  const GetPokemonDetail(this.url);
}
