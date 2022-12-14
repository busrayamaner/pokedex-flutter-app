import 'package:equatable/equatable.dart';
import 'package:pokemon_app/bloc/bottom_navigation_bar/nav_bar_items.dart';

class NavigationState extends Equatable {
  final NavbarItem navbarItem;
  final int index;

  const NavigationState(this.navbarItem, this.index);

  @override
  List<Object> get props => [navbarItem, index];
}
