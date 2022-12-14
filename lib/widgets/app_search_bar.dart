import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_app/bloc/pokemon_favourites/pokemon_favourites_cubit.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:pokemon_app/bloc/theme/theme_cubit.dart';
import 'package:pokemon_app/utils/themes.dart';

import '../bloc/pokemon_favourites/pokemon_favourites_state.dart';

class AppSearchBar extends StatefulWidget implements PreferredSizeWidget {
  const AppSearchBar(
      {Key? key,
      required this.preferredSize,
      required this.onQueryChange,
      this.opacity = 1})
      : super(key: key);

  final double opacity;
  final Function(String value) onQueryChange;

  @override
  // ignore: library_private_types_in_public_api
  _AppSearchBarState createState() => _AppSearchBarState();

  @override
  final Size preferredSize;
}

class _AppSearchBarState extends State<AppSearchBar> {
  final TextEditingController _searchQueryController = TextEditingController();

  void _searchQueryControllerListener() {
    final String text = _searchQueryController.text.toLowerCase();
    widget.onQueryChange(text);
  }

  @override
  void initState() {
    super.initState();
    _searchQueryController.addListener(_searchQueryControllerListener);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeCubit themeCubit = context.read<ThemeCubit>();
    final PokemonFavouritesCubit pokemonFavouritesCubit =
        context.read<PokemonFavouritesCubit>();
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Opacity(
          opacity: widget.opacity,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                bottom: 50,
                left: 18,
                right: 18,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Pokedex',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.headline3),
                    BlocBuilder<PokemonFavouritesCubit, PokemonFavouritesState>(
                      bloc: BlocProvider.of<PokemonFavouritesCubit>(context),
                      builder: (context, pokemonFavouritesState) {
                        return Text(
                            ("(${pokemonFavouritesState.favouritesList.length} Favourited)"),
                            style: Theme.of(context).textTheme.headline6);
                      },
                    ),
                    FlutterSwitch(
                      showOnOff: true,
                      activeText: 'DARK',
                      inactiveText: 'LIGHT',
                      valueFontSize: 8.0,
                      activeColor: const Color.fromRGBO(34, 35, 40, 1),
                      activeIcon: Icon(Icons.dark_mode_rounded,
                          color: Colors.yellow.shade50),
                      activeToggleColor: const Color.fromRGBO(20, 21, 24, 1),
                      inactiveColor: Colors.black.withOpacity(0.2),
                      inactiveIcon: Icon(
                        Icons.light_mode_rounded,
                        color: Colors.yellow.shade800,
                      ),
                      inactiveToggleColor: Colors.white,
                      value: themeCubit.getTheme() == Themes.darkTheme,
                      onToggle: (bool state) {
                        themeCubit.setTheme(
                            state ? Themes.darkTheme : Themes.lightTheme);
                      },
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: -25.0,
                left: 14.0,
                right: 14.0,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).shadowColor.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: AppBar(
                        backgroundColor: Theme.of(context).cardColor,
                        primary: false,
                        centerTitle: false,
                        flexibleSpace: Center(
                          child: TextField(
                            controller: _searchQueryController,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 17.5, horizontal: 20),
                              hintText: "Search...",
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                  color: Theme.of(context).hintColor,
                                  fontSize: 18.0),
                            ),
                          ),
                        ),
                        actions: <Widget>[
                          IconButton(
                            padding: const EdgeInsets.only(right: 12),
                            icon: Icon(
                              _searchQueryController.text != ''
                                  ? Icons.clear
                                  : Icons.search,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            onPressed: () {
                              _searchQueryController.text = '';
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
