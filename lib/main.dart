import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:scanner_pdf/Core/UI/home_screen.dart';
import 'package:scanner_pdf/common/style/cubit/theme_cubit.dart';
import 'package:scanner_pdf/common/style/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    BlocProvider(
      create: (context) => ThemeCubit(initialMode: ThemeMode.dark),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          theme: AppTheme.fromThemeMode(mode: state.mode).data,
          home: const DocScannerScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
