import 'package:bloc/bloc.dart';
import 'package:pokemon_app/bloc/bottom_navigation_bar/bottom_nav_bar_state.dart';
import 'package:pokemon_app/bloc/bottom_navigation_bar/nav_bar_items.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationState(NavbarItem.pokemonList, 0));

  void getNavBarItem(NavbarItem navbarItem) {
    switch (navbarItem) {
      case NavbarItem.pokemonList:
        emit(const NavigationState(NavbarItem.pokemonList, 0));
        break;
      case NavbarItem.favourites:
        emit(const NavigationState(NavbarItem.favourites, 1));
        break;
    }
  }
}
