part of 'search_bloc_bloc.dart';

@immutable
abstract class SearchBlocEvent extends Equatable {}

class EnterInputEvent extends SearchBlocEvent {
  final String searchInput;

  EnterInputEvent({required this.searchInput});

  @override
  List<Object> get props => [searchInput];
}
