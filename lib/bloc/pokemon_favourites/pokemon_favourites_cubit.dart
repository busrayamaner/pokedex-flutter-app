import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:pokemon_app/bloc/pokemon_favourites/pokemon_favourites_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/pokemon.dart';

class PokemonFavouritesCubit extends Cubit<PokemonFavouritesState> {
  PokemonFavouritesCubit(this.favouritesList) : super(PokemonFavouritesState(favouritesList)); 
  
  List<Result> favouritesList;

  static Future<List<Result>> fetchFavouritePokemons() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Result> initializeFavouritesList =prefs.getString("favouritesList")==null?<Result>[] : List<Result>.from(json
        .decode(prefs.getString("favouritesList")!)
        .map((x) => Result.fromJson(x)));
    return initializeFavouritesList;
  }

  void addFavourite(List<Result> favouritesList, Result favourite) async {
    if (favouritesList.contains(favourite)) {
      favouritesList.remove(favourite);
    } else {
      favouritesList.add(favourite);
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedList = json.encode(favouritesList);
    prefs.setString("favouritesList", encodedList);

    emit(PokemonFavouritesState(favouritesList));
  }
}
