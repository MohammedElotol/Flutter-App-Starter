import 'package:equatable/equatable.dart';
import 'package:flutter_app_starter/core/domain/usecases/use_case.dart';
import 'package:flutter_app_starter/core/states/result.dart';
import 'package:flutter_app_starter/products/domain/entities/product.dart';
import 'package:flutter_app_starter/products/domain/repositories/products_repository.dart';

class GetProduct implements UseCase<Product, Params> {
  final ProductsRepository repository;

  GetProduct(this.repository);

  @override
  Future<Result<Product>> call(Params params) async =>
      await repository.getProduct(id: params.productId);
}

class Params extends Equatable{
  final int productId;

  const Params({required this.productId});

  @override
  List<Object?> get props => [productId];
}