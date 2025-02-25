import 'package:flutter/material.dart';

// тем екстеншн для цветов. добавляешь новые цвета сюда по примеру.
class ColorLibrary extends ThemeExtension<ColorLibrary> {
  final Color background;
  final Color surface;
  final Color textColor;
  final Color appHeader;
  final Color card;
  final Color search;

  const ColorLibrary._({
    required this.background,
    required this.surface,
    required this.textColor,
    required this.appHeader,
    required this.card,
    required this.search,
  });

  factory ColorLibrary.dark() {
    return const ColorLibrary._(
      background: Color(0xFF000000),
      surface: Color(0xFFFFFFFF),
      textColor: Color(0xFF000000),
      appHeader: Color(0xFFFFFFFF),
      card: Color.fromARGB(255, 232, 232, 232),
      search: Color.fromARGB(255, 232, 232, 232),
    );
  }

  factory ColorLibrary.light() {
    return const ColorLibrary._(
      background: Color(0xFFFFFFFF),
      surface: Color(0xFF000000),
      textColor: Color(0xFFFFFFFF),
      appHeader: Color(0xFF000000),
      card: Color.fromARGB(255, 48, 48, 48),
      search: Color.fromARGB(255, 48, 48, 48),
    );
  }

  @override
  ColorLibrary copyWith({
    Color? background,
    Color? surface,
    Color? textColor,
    Color? appHeader,
    Color? card,
    Color? search,
  }) {
    return ColorLibrary._(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      textColor: textColor ?? this.textColor,
      appHeader: appHeader ?? this.appHeader,
      card: card ?? this.card,
      search: search ?? this.search,
    );
  }

  // lerp означает линейную интерполяцию. когда мы заменяем themedata в материал аппе, тот создает анимацию и вызывает у всех themeextension метод lerp.
  @override
  ThemeExtension<ColorLibrary> lerp(covariant ColorLibrary? other, double t) {
    if (other is! ColorLibrary) {
      return this;
    }
    return ColorLibrary._(
      // буквально: анимируй старый бэкграунд колор в новый со значением t (от 0 до 1)
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      textColor: Color.lerp(textColor, other.textColor, t)!,
      appHeader: Color.lerp(appHeader, other.appHeader, t)!,
      card: Color.lerp(card, other.card, t)!,
      search: Color.lerp(search, other.search, t)!,
    );
  }
}
