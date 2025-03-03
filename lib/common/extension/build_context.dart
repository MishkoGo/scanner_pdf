import 'package:flutter/material.dart';
import 'package:scanner_pdf/common/style/colors.dart';
import 'package:scanner_pdf/common/style/text.dart';

extension BuildContextExtension on BuildContext {
  ColorLibrary get color => Theme.of(this).extension<ColorLibrary>()!;
  TextStyleLibrary get textStyles => Theme.of(this).extension<TextStyleLibrary>()!;
}