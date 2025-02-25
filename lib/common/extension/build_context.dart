import 'package:flutter/material.dart';
import 'package:scanner_pdf/common/style/colors.dart';
import 'package:scanner_pdf/common/style/text.dart';
// запомни меня я твой кореш. ты можешь создавать extension для любого класса. очень удобно доставать например локализацию, цвета, текстовые стили просто через context.чтото.
// не путай extension и ThemeExtension, это никак не связанные вещи.
extension BuildContextExtension on BuildContext {
  ColorLibrary get color => Theme.of(this).extension<ColorLibrary>()!;
  TextStyleLibrary get textStyles => Theme.of(this).extension<TextStyleLibrary>()!;
}