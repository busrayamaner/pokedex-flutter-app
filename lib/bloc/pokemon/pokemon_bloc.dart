import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:pokemon_app/model/pokemon.dart';
import 'package:pokemon_app/model/pokemon_detail.dart';
import 'package:pokemon_app/repositories/pokemon_repository.dart';

part 'pokemon_event.dart';
part 'pokemon_state.dart';

class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  final PokemonRepository _pokemonRepository;
  Pokemon? _pokemonList;
  PokemonDetails? _pokemonDetail;
  List<Result> pokemonFavouritesList = <Result>[];
  PokemonBloc(this._pokemonRepository) : super(const PokemonInitial());

  Future<PokemonDetails?> getPokemonByNumber({required String url}) async {
    _pokemonDetail = await _pokemonRepository.getPokemonDetail(url: url);

    return _pokemonDetail;
  }

  @override
  Stream<PokemonState> mapEventToState(PokemonEvent event) async* {
    if (event is GetPokemons) {
      try {
        yield const PokemonLoading();
        await Future.delayed(const Duration(milliseconds: 400));
        _pokemonList = await _pokemonRepository.getPokemons();
        yield PokemonLoaded(_pokemonList!);
      } catch (e) {
        yield const PokemonError('An error occured. Please try again later');
      }
    }
    if (event is GetPokemonDetail) {
      _pokemonDetail =
          await _pokemonRepository.getPokemonDetail(url: event.url);
      yield PokemonDetailLoaded(_pokemonDetail!);
    }
    if (event is FavoritePokemons) {
      pokemonFavouritesList.add(event.favoritePokemons.first);
      yield PokemonFavouritesLoaded(pokemonFavouritesList);
    }

    if (event is FilterPokemons) {
      List<Result> result = _pokemonList!.results
          .where((pokemon) => pokemon.name
              .toLowerCase()
              .contains(event.filterText.toLowerCase().trim()))
          .toList();
      Pokemon pokemons = _pokemonList!;
      pokemons.results = result;
      if (event.filterText.isEmpty) {
        _pokemonList = await _pokemonRepository.getPokemons();
        yield PokemonLoaded(_pokemonList!);
      } else {
        yield PokemonLoaded(pokemons);
      }
    }
    if (event is FavoritePokemons) {
      yield PokemonFavouritesLoaded(pokemonFavouritesList);
    }
  }
}
