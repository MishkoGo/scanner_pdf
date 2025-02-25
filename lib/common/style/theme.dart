import 'package:flutter/material.dart';
import 'package:scanner_pdf/common/style/colors.dart';
import 'package:scanner_pdf/common/style/text.dart';

// просто класс с ThemeData
class AppTheme {
  final ThemeData data;

  const AppTheme._({required this.data});

  // фабричный конструктор, который принимает mode и на основе его конструирует тем дату
  factory AppTheme.fromThemeMode({required ThemeMode mode}) {
    // в зависимости от mode возвращаем цветовую либу
    final colors = switch (mode) {
      ThemeMode.system || ThemeMode.light => ColorLibrary.light(),
      ThemeMode.dark => ColorLibrary.dark(),
    };
    return AppTheme._(
      data: ThemeData(
        // в тем дате уже изначально заложен пиздилион тем для самых разных виджетов, например CircularProgressIndicatorThemeData.
        scaffoldBackgroundColor: colors.background,
        // extension позволяет прокидывать в тем дату любой класс
        extensions: [
          colors,
          TextStyleLibrary.fromColor(color: colors.textColor),
        ],
      ),
    );
  }
}