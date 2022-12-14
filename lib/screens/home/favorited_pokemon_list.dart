import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_app/bloc/pokemon_favourites/pokemon_favourites_cubit.dart';
import 'package:pokemon_app/bloc/pokemon_favourites/pokemon_favourites_state.dart';

class FavoritedPokemonList extends StatelessWidget {
  const FavoritedPokemonList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocBuilder<PokemonFavouritesCubit, PokemonFavouritesState>(
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: state.favouritesList.length,
                itemBuilder: (_, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "${index + 1}.",
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                state.favouritesList[index].name,
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              BlocProvider.of<PokemonFavouritesCubit>(context)
                                  .addFavourite(state.favouritesList,
                                      state.favouritesList[index]);
                            },
                            icon: const Icon(
                              Icons.remove_circle,
                              color: Colors.red,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    ));
  }
}
