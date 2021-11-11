import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:laporhoax/domain/entities/feed.dart';
import 'package:laporhoax/domain/usecases/get_feed_detail.dart';

part 'detail_state.dart';

class DetailCubit extends Cubit<DetailState> {
  final GetFeedDetail _detail;

  DetailCubit(this._detail) : super(DetailInitial());

  Future<void> getDetail(int id) async {
    emit(DetailLoading());
    final result = await _detail.execute(id);

    result.fold(
      (failure) => emit(DetailError(failure.message)),
      (data) => emit(DetailHasData(data)),
    );
  }
}
