/*
 * Created by andii on 12/11/21 22.55
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 22.55
 */

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:laporhoax/domain/entities/feed.dart';
import 'package:laporhoax/domain/usecases/get_feeds.dart';

class FeedCubit extends Cubit<FeedState> {
  final GetFeeds _feeds;

  FeedCubit(this._feeds) : super(FeedInitial());

  Future<void> fetchFeeds() async {
    emit(FeedLoading());
    final result = await _feeds.execute();

    result.fold(
          (failure) => emit(FeedError(failure.message)),
          (feeds) => emit(FeedHasData(feeds)),
    );
  }
}

abstract class FeedState extends Equatable {
  const FeedState();

  @override
  List<Object> get props => [];
}

class FeedInitial extends FeedState {}

class FeedLoading extends FeedState {}

class FeedError extends FeedState {
  final String message;

  FeedError(this.message);

  @override
  List<Object> get props => [message];
}

class FeedHasData extends FeedState {
  final List<Feed> data;

  FeedHasData(this.data);

  @override
  List<Object> get props => [data];
}
