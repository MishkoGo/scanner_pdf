import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'theme_state.dart';

// кубит работает по той же схеме что и провайдер. возвращает state.
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit({required ThemeMode initialMode})
      : super(ThemeState(mode: initialMode));

  void toggleTheme() {
    // возвращаем противоположную тему. если их больше двух - тогда выражение станет чуть сложнее :)
    emit(
      ThemeState(
        mode: switch (state.mode) {
          ThemeMode.system || ThemeMode.light => ThemeMode.dark,
          _ => ThemeMode.light,
        },
      ),
    );
    //sharedPrefs.setString('dark');
  }
}