
import 'package:flutter/foundation.dart';
import 'package:flutter_app_starter/core/error/network_exception.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'async_state.freezed.dart';

@freezed
abstract class AsyncState<T> with _$AsyncState<T> {
  const factory AsyncState.idle() = Idle<T>;

  const factory AsyncState.loading() = Loading<T>;

  const factory AsyncState.data({required T data}) = Data<T>;

  const factory AsyncState.error({required NetworkException error}) =
  Error<T>;
}