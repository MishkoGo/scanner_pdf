import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('en'); // Язык по умолчанию
  static const String _localeKey = 'selected_locale'; // Ключ для SharedPreferences

  LocaleProvider() {
    // Загружаем сохранённый язык при инициализации
    loadLocale();
  }

  Locale get locale => _locale;

  // Загрузка сохранённого языка из SharedPreferences
  Future<void> loadLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLocale = prefs.getString(_localeKey);
      print('Загруженный язык из SharedPreferences: $savedLocale');
      if (savedLocale != null) {
        _locale = Locale(savedLocale);
        notifyListeners();
      }
    } catch (e) {
      print('Ошибка загрузки языка: $e');
    }
  }

  // Установка нового языка и сохранение его в SharedPreferences
  Future<void> setLocale(Locale locale) async {
    try {
      _locale = locale;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, locale.languageCode);
      print('Сохранённый язык в SharedPreferences: ${locale.languageCode}');
      notifyListeners();
    } catch (e) {
      print('Ошибка сохранения языка: $e');
    }
  }
}