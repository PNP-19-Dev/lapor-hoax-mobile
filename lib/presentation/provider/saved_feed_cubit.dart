import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:laporhoax/domain/entities/feed.dart';
import 'package:laporhoax/domain/usecases/get_saved_feeds.dart';

class SavedFeedCubit extends Cubit<SavedFeedState> {
  final GetSavedFeeds _getFeeds;

  SavedFeedCubit(this._getFeeds) : super(SavedFeedInitial());

  Future<void> fetchSavedCubit() async {
    emit(SavedFeedLoading());
    final result = await _getFeeds.execute();

    result.fold(
      (failure) => emit(SavedFeedError(failure.message)),
      (data) => data.isEmpty
          ? emit(SavedFeedEmpty('Kamu belum menyimpan berita apapun!'))
          : emit(SavedFeedHasData(data)),
    );
  }
}

abstract class SavedFeedState extends Equatable {
  const SavedFeedState();

  @override
  List<Object?> get props => [];
}

class SavedFeedInitial extends SavedFeedState {}

class SavedFeedEmpty extends SavedFeedState {
  final String message;

  const SavedFeedEmpty(this.message);

  @override
  List<Object?> get props => [message];
}

class SavedFeedLoading extends SavedFeedState {}

class SavedFeedError extends SavedFeedState {
  final String message;

  const SavedFeedError(this.message);

  @override
  List<Object?> get props => [message];
}

class SavedFeedHasData extends SavedFeedState {
  final List<Feed> feeds;

  const SavedFeedHasData(this.feeds);

  @override
  List<Object?> get props => [feeds];
}
