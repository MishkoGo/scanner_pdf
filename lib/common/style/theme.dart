import 'package:flutter/material.dart';
import 'package:scanner_pdf/common/style/colors.dart';
import 'package:scanner_pdf/common/style/text.dart';

class AppTheme {
  final ThemeData data;

  const AppTheme._({required this.data});

  factory AppTheme.fromThemeMode({required ThemeMode mode}) {
    final colors = switch (mode) {
      ThemeMode.system || ThemeMode.light => ColorLibrary.light(),
      ThemeMode.dark => ColorLibrary.dark(),
    };
    return AppTheme._(
      data: ThemeData(
        scaffoldBackgroundColor: colors.background,
        extensions: [
          colors,
          TextStyleLibrary.fromColor(color: colors.textColor),
        ],
      ),
    );
  }
}