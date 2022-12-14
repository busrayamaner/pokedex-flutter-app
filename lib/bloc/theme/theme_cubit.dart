import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pokemon_app/bloc/theme/theme_state.dart';
import 'package:pokemon_app/utils/constants.dart';
import 'package:pokemon_app/utils/themes.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeData _appTheme = Themes.lightTheme;

  ThemeCubit(ThemeData appTheme) : super(ThemeState(appTheme: appTheme)) {
    _appTheme = appTheme;
    emit(ThemeState(appTheme: appTheme));
  }

  void setTheme(ThemeData theme) async {
    _appTheme = theme;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(IS_DARK_MODE, theme == Themes.darkTheme);

    emit(ThemeState(appTheme: theme));
  }

  ThemeData getTheme() {
    return _appTheme;
  }

  bool isDarkMode() {
    return _appTheme == Themes.darkTheme;
  }
}
