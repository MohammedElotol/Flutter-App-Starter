import 'package:flutter_app_starter/core/states/result.dart';
import 'package:flutter_app_starter/products/domain/entities/product.dart';

abstract class ProductsRepository {
  Future<Result<List<Product>>> getAllProducts();

  Future<Result<Product>> getProduct({required int id});
}
