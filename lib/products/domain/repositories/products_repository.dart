import 'package:flutter_app_starter/config/states/result.dart';
import 'package:flutter_app_starter/products/domain/entities/product.dart';

abstract class ProductsRepository{
  Future<Result<List<Product>>> getAllProducts();
  Future<Result<Product>> getProduct({int id});
}