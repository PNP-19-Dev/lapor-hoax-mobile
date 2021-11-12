/*
 * Created by andii on 12/11/21 22.55
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 22.55
 */

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:laporhoax/domain/entities/feed.dart';
import 'package:laporhoax/domain/usecases/get_feed_save_status.dart';
import 'package:laporhoax/domain/usecases/remove_feed.dart';
import 'package:laporhoax/domain/usecases/save_feed.dart';

part 'item_state.dart';

class ItemCubit extends Cubit<ItemState> {
  final GetFeedSaveStatus _status;
  final SaveFeed _save;
  final RemoveFeed _remove;

  ItemCubit(this._status,
      this._save,
      this._remove,) : super(ItemInitial());

  Future<void> getStatus(int id) async {
    final result = await _status.execute(id);
    if (result) {
      emit(ItemIsSave());
    } else
      emit(ItemUnsaved());
  }

  Future<void> saveFeed(Feed feed) async {
    final result = await _save.execute(feed);
    result.fold(
          (failure) => emit(ItemSaveError(failure.message)),
          (success) => emit(ItemSaved(success)),
    );
  }

  Future<void> removeFeed(Feed feed) async {
    final result = await _remove.execute(feed);
    result.fold(
          (failure) => emit(ItemSaveError(failure.message)),
          (success) => emit(ItemRemoved(success)),
    );
  }
}
