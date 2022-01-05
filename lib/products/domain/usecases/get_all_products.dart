import 'package:flutter_app_starter/config/states/result.dart';
import 'package:flutter_app_starter/core/domain/usecases/use_case.dart';
import 'package:flutter_app_starter/products/domain/entities/product.dart';
import 'package:flutter_app_starter/products/domain/repositories/products_repository.dart';

class GetProducts implements UseCase<List<Product>, NoParams> {
  final ProductsRepository repository;

  GetProducts(this.repository);

  @override
  Future<Result<List<Product>>> call(NoParams params) async =>
      await repository.getAllProducts();
}
