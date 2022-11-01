part of 'favourite_bloc.dart';

abstract class FavouriteEvent extends Equatable {
  const FavouriteEvent();
}

class FavouriteRemoveEvent extends FavouriteEvent {
  final int index;

  FavouriteRemoveEvent({required this.index});

  @override
  List<Object?> get props => [index];
}
