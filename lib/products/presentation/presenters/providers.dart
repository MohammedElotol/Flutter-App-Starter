import 'package:dio/dio.dart';
import 'package:flutter_app_starter/core/domain/usecases/use_case.dart';
import 'package:flutter_app_starter/core/network/dio_client.dart';
import 'package:flutter_app_starter/core/network/network_info.dart';
import 'package:flutter_app_starter/core/states/async_state.dart';
import 'package:flutter_app_starter/core/states/result.dart';
import 'package:flutter_app_starter/products/data/datasources/products_local_datasource.dart';
import 'package:flutter_app_starter/products/data/datasources/products_remote_datasource.dart';
import 'package:flutter_app_starter/products/data/repositories/products_repository_impl.dart';
import 'package:flutter_app_starter/products/domain/entities/product.dart';
import 'package:flutter_app_starter/products/domain/repositories/products_repository.dart';
import 'package:flutter_app_starter/products/domain/usecases/get_all_products.dart';
import 'package:flutter_app_starter/products/domain/usecases/get_product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

final baseUrlProvider = Provider<String>((ref) {
  return 'https://fakestoreapi.com/';
});
final sharedPreferencesProvider =
    Provider<SharedPreferences>((ref) => throw UnimplementedError());
final dioProvider = Provider<Dio>((ref) => Dio());

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient(Dio(), baseUrl: ref.watch(baseUrlProvider));
});

final internetConnectionCheckerProvider =
    Provider<InternetConnectionChecker>((ref) => InternetConnectionChecker());

final networkInfoProvider = Provider<NetworkInfo>(
    (ref) => NetworkInfoImpl(ref.watch(internetConnectionCheckerProvider)));

final productsRemoteDataSourceProvider = Provider<ProductsRemoteDataSource>(
    (ref) => ProductRemoteDataSourceRetrofitImpl(ref.watch(
        dioProvider))); //ProductsRemoteDataSourceImpl(ref.watch(dioClientProvider))

final productsLocalDataSourceProvider = Provider<ProductsLocalDataSource>(
    (ref) => ProductsLocalDataSourceImpl(
        sharedPreferences: ref.watch(sharedPreferencesProvider)));

final productsRepositoryProvider = Provider<ProductsRepository>((ref) =>
    ProductsRepositoryImpl(
        remoteDataSource: ref.watch(productsRemoteDataSourceProvider),
        localDataSource: ref.watch(productsLocalDataSourceProvider),
        networkInfo: ref.watch(networkInfoProvider)));

final getProductsProvider = Provider<GetProducts>(
    (ref) => GetProducts(ref.watch(productsRepositoryProvider)));

final getProductProvider = Provider<GetProduct>(
    (ref) => GetProduct(ref.watch(productsRepositoryProvider)));

final productsProvider = FutureProvider<List<Product>>((ref) async {
  final Result<List<Product>> result =
      await ref.watch(getProductsProvider).call(const NoParams());

  return result.when(
      success: (data) => data,
      error: (error) {
        print(error.toString());
        throw error;
      });
});

final shortProductProvider = Provider<Product>((ref) {
  throw UnimplementedError();
});

final productProvider = FutureProvider.autoDispose
    .family<AsyncState<Product>, int>((ref, productId) async {
  const AsyncState.loading();
  final Result<Product> result =
      await ref.watch(getProductProvider).call(Params(productId: productId));
  return result.when(
      success: (data) => AsyncState.data(data: data),
      error: (error) => AsyncState.error(error: error));
});
