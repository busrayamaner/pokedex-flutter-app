import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pokemon_app/bloc/pokemon_favourites/pokemon_favourites_cubit.dart';
import 'package:pokemon_app/bloc/pokemon_favourites/pokemon_favourites_state.dart';
import 'package:pokemon_app/model/pokemon.dart';
import '../../bloc/pokemon/pokemon_bloc.dart';
import '../../widgets/no_results.dart';
import '../pokemon_detail/pokemon_detail.dart';

class PokemonItem extends StatefulWidget {
  const PokemonItem({Key? key, required this.pokemon}) : super(key: key);

  final Result pokemon;

  @override
  State<PokemonItem> createState() => _PokemonItemState();
}

class _PokemonItemState extends State<PokemonItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              child: PokemonDetail(url: widget.pokemon.url),
            ),
          );
        },
        child: BlocBuilder(
          bloc: BlocProvider.of<PokemonBloc>(context),
          builder: (context, state) {
            if (state is PokemonLoaded) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2.0,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 14, left: 14, right: 14, bottom: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BlocBuilder<PokemonFavouritesCubit,
                              PokemonFavouritesState>(
                          bloc:
                              BlocProvider.of<PokemonFavouritesCubit>(context),
                          builder: (context, state) {
                            bool isFavourite = state.favouritesList
                                .where(
                                  (element) =>
                                      element.url == widget.pokemon.url,
                                )
                                .isNotEmpty;
                            return GestureDetector(
                              onTap: () {
                                BlocProvider.of<PokemonFavouritesCubit>(context)
                                    .addFavourite(
                                        state.favouritesList, widget.pokemon);
                              },
                              child: Icon(
                                isFavourite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavourite ? Colors.red : Colors.grey,
                              ),
                            );
                          }),
                      const SizedBox(height: 20),
                      Text(widget.pokemon.name,
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.headline6),
                    ],
                  ),
                ),
              );
            } else if (state is PokemonLoading) {
              return Center(
                  child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.onSurface));
            } else if (state is PokemonError) {
              return const NoResults(
                  description: 'No pokémon found matching your search.');
            } else {
              return Center(
                  child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.onSurface));
            }
          },
        ),
      ),
    );
  }
}
