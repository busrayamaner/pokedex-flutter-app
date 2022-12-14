import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_app/bloc/bottom_navigation_bar/bottom_nav_bar_state.dart';
import 'package:pokemon_app/bloc/bottom_navigation_bar/bottom_nav_bar_cubit.dart';
import 'package:pokemon_app/bloc/bottom_navigation_bar/nav_bar_items.dart';
import 'package:pokemon_app/bloc/pokemon/pokemon_bloc.dart';
import 'package:pokemon_app/bloc/theme/theme_cubit.dart';
import 'package:pokemon_app/screens/home/favorited_pokemon_list.dart';
import 'package:pokemon_app/screens/home/pokemon_list.dart';
import 'package:pokemon_app/widgets/app_search_bar.dart';
import 'package:pokemon_app/widgets/no_results.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String filterText = '';

  @override
  void initState() {
    super.initState();
    BlocProvider.of<PokemonBloc>(context).add(const GetPokemons());
  }

  @override
  Widget build(BuildContext context) {
    const double toolbarHeight = kToolbarHeight + 110;
    final ThemeCubit themeCubit = context.read<ThemeCubit>();
    final NavigationCubit navCubit = context.read<NavigationCubit>();

    return AnnotatedRegion(
      value: themeCubit.isDarkMode()
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: NestedScrollView(
          clipBehavior: Clip.none,
          floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  backgroundColor: Colors.transparent,
                  collapsedHeight: toolbarHeight,
                  expandedHeight: toolbarHeight,
                  flexibleSpace: navCubit.state.navbarItem ==
                          NavbarItem.pokemonList
                      ? AppSearchBar(
                          preferredSize: const Size.fromHeight(toolbarHeight),
                          onQueryChange: (String text) {
                            BlocProvider.of<PokemonBloc>(context)
                                .add(FilterPokemons(text));
                          },
                        )
                      : null,
                  floating: true,
                  pinned: false,
                  snap: true,
                  elevation: 0,
                ),
              ),
            ];
          },
          body: BlocBuilder<NavigationCubit, NavigationState>(
            builder: homePagebody,
          ),
        ),
        bottomNavigationBar: BlocBuilder<NavigationCubit, NavigationState>(
          builder: (context, state) {
            return BottomNavigationBar(
              currentIndex: state.index,
              showUnselectedLabels: false,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.grid_view_outlined,
                  ),
                  label: 'Pokemons',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.favorite,
                  ),
                  label: 'Favourites',
                ),
              ],
              onTap: (index) {
                if (index == 0) {
                  BlocProvider.of<NavigationCubit>(context)
                      .getNavBarItem(NavbarItem.pokemonList);
                } else if (index == 1) {
                  BlocProvider.of<NavigationCubit>(context)
                      .getNavBarItem(NavbarItem.favourites);
                }
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          splashColor: Theme.of(context).colorScheme.primaryContainer,
          onPressed: () {
            BlocProvider.of<PokemonBloc>(context).add(const GetPokemons());
          },
          child: Icon(Icons.refresh,
              color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
    );
  }

  Widget homePagebody(context, state) {
    if (state.navbarItem == NavbarItem.pokemonList) {
      return BlocBuilder(
        bloc: BlocProvider.of<PokemonBloc>(context),
        builder: (context, state) {
          if (state is PokemonLoaded) {
            return PokemonList(pokemon: state.pokemonList);
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
      );
    } else if (state.navbarItem == NavbarItem.favourites) {
      return const FavoritedPokemonList();
    }
    return Container();
  }
}
