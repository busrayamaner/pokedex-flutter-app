

import '../../model/pokemon.dart';

class PokemonFavouritesState  {

  
   List<Result> favouritesList;


   PokemonFavouritesState(this.favouritesList);

  @override
  List<Object> get props => [favouritesList];
}
