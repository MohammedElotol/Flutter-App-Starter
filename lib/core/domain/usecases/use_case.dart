import 'package:flutter_app_starter/config/states/result.dart';

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'use_case.freezed.dart';

abstract class UseCase<T, Params>{
  Future<Result<T>> call(Params params);
}

@freezed
class NoParams with _$NoParams {
  const factory NoParams() = _NoParams;
}