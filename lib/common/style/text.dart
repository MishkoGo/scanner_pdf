import 'package:flutter/material.dart';

class TextStyleLibrary extends ThemeExtension<TextStyleLibrary> {
  final TextStyle h1;
  final TextStyle body;
  final TextStyle button;

  const TextStyleLibrary._({
    required this.h1,
    required this.body,
    required this.button,
  });

  factory TextStyleLibrary.fromColor({required Color color}) {
    return TextStyleLibrary._(
      h1: TextStyle(fontSize: 18, color: color),
      body: TextStyle(fontSize: 21, color: color),
      button: TextStyle(fontSize: 13, color: color),
    );
  }

  @override
  TextStyleLibrary copyWith({TextStyle? h1, TextStyle? body, TextStyle? button}) {
    return TextStyleLibrary._(h1: h1 ?? this.h1, body: body ?? this.body, button: button ?? this.button);
  }

  @override
  ThemeExtension<TextStyleLibrary> lerp(
    covariant TextStyleLibrary? other,
    double t,
  ) {
    if (other is! TextStyleLibrary) {
      return this;
    }
    return TextStyleLibrary._(h1: other.h1, body: other.body, button: other.button);
  }
}
