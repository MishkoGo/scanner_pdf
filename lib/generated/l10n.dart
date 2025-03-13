// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `hello!`
  String get hello {
    return Intl.message('hello!', name: 'hello', desc: '', args: []);
  }

  /// `Documents`
  String get documents {
    return Intl.message('Documents', name: 'documents', desc: '', args: []);
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Subscription on Pro`
  String get subscription {
    return Intl.message(
      'Subscription on Pro',
      name: 'subscription',
      desc: '',
      args: [],
    );
  }

  /// `Manage Subscription`
  String get manage_subscription {
    return Intl.message(
      'Manage Subscription',
      name: 'manage_subscription',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `English`
  String get current_language {
    return Intl.message(
      'English',
      name: 'current_language',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get political {
    return Intl.message(
      'Privacy Policy',
      name: 'political',
      desc: '',
      args: [],
    );
  }

  /// `Terms of use`
  String get rules_uses {
    return Intl.message('Terms of use', name: 'rules_uses', desc: '', args: []);
  }

  /// `Not activated`
  String get status_subscription {
    return Intl.message(
      'Not activated',
      name: 'status_subscription',
      desc: '',
      args: [],
    );
  }

  /// `Rename document`
  String get rename_document {
    return Intl.message(
      'Rename document',
      name: 'rename_document',
      desc: '',
      args: [],
    );
  }

  /// `Enter a new document name`
  String get new_name_document {
    return Intl.message(
      'Enter a new document name',
      name: 'new_name_document',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Here is the document`
  String get this_document {
    return Intl.message(
      'Here is the document',
      name: 'this_document',
      desc: '',
      args: [],
    );
  }

  /// `Enter document title`
  String get enter_name_document {
    return Intl.message(
      'Enter document title',
      name: 'enter_name_document',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Rename`
  String get rename {
    return Intl.message('Rename', name: 'rename', desc: '', args: []);
  }

  /// `View`
  String get view {
    return Intl.message('View', name: 'view', desc: '', args: []);
  }

  /// `Restore`
  String get restore {
    return Intl.message('Restore', name: 'restore', desc: '', args: []);
  }

  /// `Skip`
  String get skip {
    return Intl.message('Skip', name: 'skip', desc: '', args: []);
  }

  /// `Upgrade to Pro version and \n get access to all \n application capabilities`
  String get update_header {
    return Intl.message(
      'Upgrade to Pro version and \n get access to all \n application capabilities',
      name: 'update_header',
      desc: '',
      args: [],
    );
  }

  /// `Batch scanning \n Export without restrictions \n Unlimited number of scans \n Text recognition \n`
  String get update_desc {
    return Intl.message(
      'Batch scanning \n Export without restrictions \n Unlimited number of scans \n Text recognition \n',
      name: 'update_desc',
      desc: '',
      args: [],
    );
  }

  /// `Pro (7 days) 339,00 ₽`
  String get price_1 {
    return Intl.message(
      'Pro (7 days) 339,00 ₽',
      name: 'price_1',
      desc: '',
      args: [],
    );
  }

  /// `Pro (1 mouht) 739,00 ₽`
  String get price_2 {
    return Intl.message(
      'Pro (1 mouht) 739,00 ₽',
      name: 'price_2',
      desc: '',
      args: [],
    );
  }

  /// `Pro (3 mouht) 1 450,00 ₽`
  String get price_3 {
    return Intl.message(
      'Pro (3 mouht) 1 450,00 ₽',
      name: 'price_3',
      desc: '',
      args: [],
    );
  }

  /// `Pro (1 year) 2 170,00 ₽`
  String get price_4 {
    return Intl.message(
      'Pro (1 year) 2 170,00 ₽',
      name: 'price_4',
      desc: '',
      args: [],
    );
  }

  /// `Start your free trial`
  String get test_period {
    return Intl.message(
      'Start your free trial',
      name: 'test_period',
      desc: '',
      args: [],
    );
  }

  /// `Trial period 7 days. Can be canceled at any time.`
  String get test_period_desc {
    return Intl.message(
      'Trial period 7 days. Can be canceled at any time.',
      name: 'test_period_desc',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english_lang {
    return Intl.message('English', name: 'english_lang', desc: '', args: []);
  }

  /// `Russian`
  String get russian_lang {
    return Intl.message('Russian', name: 'russian_lang', desc: '', args: []);
  }

  /// `Spanish (Mexico)`
  String get espan_lang {
    return Intl.message(
      'Spanish (Mexico)',
      name: 'espan_lang',
      desc: '',
      args: [],
    );
  }

  /// `Ukranian`
  String get ukraine_lang {
    return Intl.message('Ukranian', name: 'ukraine_lang', desc: '', args: []);
  }

  /// `Chinese (Simplified)`
  String get chinese_lang {
    return Intl.message(
      'Chinese (Simplified)',
      name: 'chinese_lang',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'cn'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'uk'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
