part of 'search_bloc_bloc.dart';

@immutable
abstract class SearchBlocState extends Equatable {}

class SearchResult extends SearchBlocState {
  final List<Audio> audios;

  SearchResult({required this.audios});

  @override
  List<Object?> get props => audios;
}
