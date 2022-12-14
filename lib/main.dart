import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_app/bloc/bottom_navigation_bar/bottom_nav_bar_cubit.dart';
import 'package:pokemon_app/bloc/pokemon/pokemon_bloc.dart';
import 'package:pokemon_app/bloc/pokemon_favourites/pokemon_favourites_cubit.dart';
import 'package:pokemon_app/bloc/theme/theme_cubit.dart';
import 'package:pokemon_app/bloc/theme/theme_state.dart';
import 'package:pokemon_app/repositories/pokemon_repository.dart';
import 'package:pokemon_app/utils/themes.dart';
import 'package:pokemon_app/screens/home/home.dart';
import 'model/pokemon.dart';

void main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      bool isDarkMode = await Themes.isDarkMode();
      List<Result> getFavourites =
          await PokemonFavouritesCubit.fetchFavouritePokemons();
      runApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<ThemeCubit>(
                create: (context) => ThemeCubit(
                    isDarkMode ? Themes.darkTheme : Themes.lightTheme)),
            BlocProvider<NavigationCubit>(
                create: (context) => NavigationCubit()),
            BlocProvider<PokemonFavouritesCubit>(
                create: (context) => PokemonFavouritesCubit(getFavourites)),
            BlocProvider<PokemonBloc>(
                create: (context) => PokemonBloc(PokemonRepository())),
          ],
          child: const App(),
        ),
      );
    },
    (error, st) => print(error),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, ThemeState state) {
        return MaterialApp(
          title: "Pokémon App",
          home: const Home(),
          debugShowCheckedModeBanner: false,
          theme: state.appTheme,
        );
      },
    );
  }
}
    