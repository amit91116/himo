part of 'theme_bloc.dart';

@immutable
class ThemeState extends Equatable {
  final ThemeData themeData;

  const ThemeState(this.themeData);

  @override
  List<Object?> get props => [themeData];
}

class ThemeInitial extends ThemeState {
  const ThemeInitial(themeData) : super(themeData);

  @override
  List<Object> get props => [themeData];
}
