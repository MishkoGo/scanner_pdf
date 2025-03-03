import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit({required ThemeMode initialMode})
      : super(ThemeState(mode: initialMode));

  void toggleTheme() {
    emit(
      ThemeState(
        mode: switch (state.mode) {
          ThemeMode.system || ThemeMode.light => ThemeMode.dark,
          _ => ThemeMode.light,
        },
      ),
    );
  }
}