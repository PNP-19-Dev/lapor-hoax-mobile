/*
 * Created by andii on 12/11/21 22.55
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 22.52
 */

part of 'detail_cubit.dart';

abstract class DetailState extends Equatable {
  const DetailState();

  @override
  List<Object> get props => [];
}

class DetailInitial extends DetailState {}

class DetailLoading extends DetailState {}

class DetailError extends DetailState {
  final String message;

  DetailError(this.message);

  @override
  List<Object> get props => [message];
}

class DetailHasData extends DetailState {
  final Feed data;

  DetailHasData(this.data);

  @override
  List<Object> get props => [data];
}
