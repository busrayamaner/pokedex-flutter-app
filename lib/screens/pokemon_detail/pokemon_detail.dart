import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_app/bloc/pokemon/pokemon_bloc.dart';
import 'package:pokemon_app/bloc/theme/theme_cubit.dart';
import 'package:pokemon_app/model/pokemon_detail.dart';
import 'package:pokemon_app/utils/constants.dart';
import 'package:pokemon_app/widgets/no_results.dart';

class PokemonDetail extends StatefulWidget {
  const PokemonDetail({super.key, required this.url});
  final String url;
  @override
  State<PokemonDetail> createState() => _PokemonDetailState();
}

class _PokemonDetailState extends State<PokemonDetail> {
  @override
  void initState() {
    BlocProvider.of<PokemonBloc>(context).add(GetPokemonDetail(widget.url));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    late Color backgroundColor;
    final ThemeCubit themeCubit = context.read<ThemeCubit>();

    if (themeCubit.isDarkMode()) {
      backgroundColor = Theme.of(context).primaryColor;
    } else {
      backgroundColor = AppColors.appPrimaryColor;
    }

    return WillPopScope(
      onWillPop: () async {
        BlocProvider.of<PokemonBloc>(context).add(const GetPokemons());
        Navigator.popUntil(context, (route) => route.isFirst);
        return false;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: backgroundColor,
        ),
        body: BlocBuilder(
          builder: (context, state) {
            if (state is PokemonDetailLoaded) {
              return pokemonDetail(context, state.pokemonDetail);
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
          bloc: BlocProvider.of<PokemonBloc>(context),
        ),
      ),
    );
  }

  pokemonDetail(BuildContext context, PokemonDetails pokemonDetail) {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 180.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(50),
                      topLeft: Radius.circular(50),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const SizedBox(height: 80),
                              Text(pokemonDetail.name,
                                  style: Theme.of(context).textTheme.headline4),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Divider(height: 5),
                              ),
                              propWidget("Height: ${pokemonDetail.height}"),
                              propWidget("Weight: ${pokemonDetail.weight}"),
                              propWidget("Order: ${pokemonDetail.order}"),
                              propWidget(
                                  "Base Experience: ${pokemonDetail.baseExperience}"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Container propWidget(String bodyText) {
    return Container(
      decoration: BoxDecoration(
        border:
            Border.all(color: Colors.black, width: 3, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(20.0),
        gradient: LinearGradient(
          colors: [AppColors.appSecondaryColor, Colors.white, Colors.white],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.all(5.0),
      child: Text(
        bodyText,
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }
}
