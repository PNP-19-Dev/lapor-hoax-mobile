part of 'item_cubit.dart';

abstract class ItemState extends Equatable {
  const ItemState();

  @override
  List<Object> get props => [];
}

class ItemInitial extends ItemState {}

class ItemSaveError extends ItemState {
  final String message;

  ItemSaveError(this.message);

  @override
  List<Object> get props => [message];
}

class ItemIsSave extends ItemState {}

class ItemUnsaved extends ItemState {}

class ItemSaved extends ItemState {
  final String message;

  ItemSaved(this.message);

  @override
  List<Object> get props => [message];
}

class ItemRemoved extends ItemState {
  final String message;

  ItemRemoved(this.message);

  @override
  List<Object> get props => [message];
}
