import 'package:pokemon_app/model/pokemon.dart';
import 'package:pokemon_app/model/pokemon_detail.dart';
import 'package:pokemon_app/utils/constants.dart';
import 'package:pokemon_app/utils/network.dart';

class PokemonRepository {
  PokemonRepository();
  final networkManager = NetworkManager();

  Future<Pokemon> getPokemons() async {
    final response =
        await networkManager.request(RequestMethod.get, AppConstants.baseUrl);
    final data = Pokemon.fromJson(response.data);
    return data;
  }

  Future<PokemonDetails> getPokemonDetail({required String url}) async {
    final response = await networkManager.request(RequestMethod.get, url);
    final data = PokemonDetails.fromJson(response.data);

    return data;
  }
}
