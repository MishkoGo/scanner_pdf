import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:scanner_pdf/Core/UI/doc_scanner_screen.dart';
import 'package:scanner_pdf/common/models/document_provider.dart';
import 'package:scanner_pdf/common/models/localeProvider.dart';
import 'package:scanner_pdf/common/style/cubit/theme_cubit.dart';
import 'package:scanner_pdf/common/style/theme.dart';
import 'package:scanner_pdf/generated/l10n.dart';
import 'package:scanner_pdf/l10n/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DocumentProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: BlocProvider(
        create: (context) => ThemeCubit(initialMode: ThemeMode.dark),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          theme: AppTheme.fromThemeMode(mode: state.mode).data,
          home: const DocScannerScreen(),
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: localeProvider.locale,
          supportedLocales: S.delegate.supportedLocales,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
