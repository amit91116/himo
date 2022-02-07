import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import '../app_theme.dart';

part 'theme_event.dart';

part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeInitial(appThemeData[AppTheme.light]!)) {
    on<InitializeTheme>((event, emit) async {
      final SharedPreferences _prefs = await SharedPreferences.getInstance();
      String? _theme = _prefs.getString(Constants.theme);
      AppTheme theme = getThemeEnum(_theme ?? "light");
      emit.call(ThemeState(appThemeData[theme]!));
    });

    on<ThemeChanged>((event, emit) async {
      final SharedPreferences _prefs = await SharedPreferences.getInstance();
      _prefs.setString(Constants.theme, getThemeString(event.theme));
      emit.call(ThemeState(appThemeData[event.theme]!));
    });
  }
}
