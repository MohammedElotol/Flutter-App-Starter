import 'package:flutter_app_starter/core/error/exceptions.dart';
import 'package:flutter_app_starter/core/error/failure.dart';
import 'package:flutter_app_starter/core/network/network_info.dart';
import 'package:flutter_app_starter/core/states/result.dart';
import 'package:flutter_app_starter/products/data/datasources/products_local_datasource.dart';
import 'package:flutter_app_starter/products/data/datasources/products_remote_datasource.dart';
import 'package:flutter_app_starter/products/domain/entities/product.dart';
import 'package:flutter_app_starter/products/domain/repositories/products_repository.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDataSource remoteDataSource;
  final ProductsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProductsRepositoryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});

  @override
  Future<Result<List<Product>>> getAllProducts() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProducts = await remoteDataSource.getProducts();
        localDataSource.cacheProducts(products: remoteProducts);
        return Result.success(data: remoteProducts);
      } on ServerException {
        return const Result.error(error: ServerFailure());
      }
    } else {
      try {
        final localProducts = await localDataSource.getLastProducts();
        return Result.success(data: localProducts);
      } on CacheException {
        return const Result.error(error: CacheFailure());
      }
    }
  }

  @override
  Future<Result<Product>> getProduct({required int id}) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProduct = await remoteDataSource.getProduct(id: id);
        localDataSource.cacheProduct(product: remoteProduct);
        return Result.success(data: remoteProduct);
      } on ServerException {
        return const Result.error(error: ServerFailure());
      }
    } else {
      try {
        final localProduct = await localDataSource.getCachedProduct(id: id);
        return Result.success(data: localProduct);
      } on CacheException {
        return const Result.error(error: CacheFailure());
      }
    }
  }
}
