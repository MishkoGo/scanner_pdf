part of 'theme_cubit.dart';

// собственно состояние твоей темы. 
@immutable
final class ThemeState {
  final ThemeMode mode;
  const ThemeState({required this.mode});
}