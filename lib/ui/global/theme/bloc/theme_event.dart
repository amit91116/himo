part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  final AppTheme theme;

  const ThemeEvent(this.theme);
}

class InitializeTheme extends ThemeEvent {
  const InitializeTheme(theme) : super(theme);

  @override
  List<Object?> get props => [];
}

class ThemeChanged extends ThemeEvent {
  const ThemeChanged(theme) : super(theme);

  @override
  List<Object?> get props => [theme];
}
