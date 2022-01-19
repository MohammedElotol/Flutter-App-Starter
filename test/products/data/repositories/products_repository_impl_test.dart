import 'package:flutter_app_starter/core/error/exceptions.dart';
import 'package:flutter_app_starter/core/error/failure.dart';
import 'package:flutter_app_starter/core/network/network_info.dart';
import 'package:flutter_app_starter/core/states/result.dart';
import 'package:flutter_app_starter/products/data/datasources/products_local_datasource.dart';
import 'package:flutter_app_starter/products/data/datasources/products_remote_datasource.dart';
import 'package:flutter_app_starter/products/data/models/product_model.dart';
import 'package:flutter_app_starter/products/data/repositories/products_repository_impl.dart';
import 'package:flutter_app_starter/products/domain/entities/product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'products_repository_impl_test.mocks.dart';

@GenerateMocks([ProductsRemoteDataSource, ProductsLocalDataSource, NetworkInfo])
main() {
  late ProductsRepositoryImpl repository;
  late MockProductsRemoteDataSource mockRemoteDataSource;
  late MockProductsLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockProductsRemoteDataSource();
    mockLocalDataSource = MockProductsLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ProductsRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo);
  });
  void runTestOnline(Function body) {
    group('Device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected)
            .thenAnswer((realInvocation) async => true);
      });
      body();
    });
  }

  void runTestOffline(Function body) {
    group('Device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected)
            .thenAnswer((realInvocation) async => false);
      });
      body();
    });
  }

  group('getProducts', () {
    final List<ProductModel> tProductModels = [
      ProductModel(
          id: 1,
          title: 'title',
          price: 100,
          description: 'description',
          category: 'category',
          image: 'image')
    ];

    final List<Product> tProducts = tProductModels;

    test('should check if the device is online', () {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((realInvocation) async => true);
      when(mockRemoteDataSource.getProducts())
          .thenAnswer((realInvocation) async => tProductModels);
      repository.getAllProducts();
      verify(mockNetworkInfo.isConnected);
    });

    runTestOnline(() {
      test(
          'should return the remote data when the call to remote data is successful',
          () async {
        when(mockRemoteDataSource.getProducts())
            .thenAnswer((realInvocation) async => tProductModels);
        final result = await repository.getAllProducts();

        verify(mockRemoteDataSource.getProducts());
        expect(result, equals(Result.success(data: tProducts)));
      });

      test(
          'should cache the data locally when the call to remote data is successful',
          () async {
        when(mockRemoteDataSource.getProducts())
            .thenAnswer((realInvocation) async => tProductModels);
        await repository.getAllProducts();

        verify(mockRemoteDataSource.getProducts());
        verify(mockLocalDataSource.cacheProducts(products: tProductModels));
      });

      test(
          'should return server failure when the call to remote data is unsuccessful',
          () async {
        when(mockRemoteDataSource.getProducts()).thenThrow(ServerException());
        final result = await repository.getAllProducts();

        verify(mockRemoteDataSource.getProducts());
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Result<List<Product>>.error(error: ServerFailure())));
      });
    });

    runTestOffline(() {
      test(
          'Should return last locally cached data when the cached data is present',
          () async {
        when(mockLocalDataSource.getLastProducts())
            .thenAnswer((realInvocation) async => tProductModels);

        final result = await repository.getAllProducts();

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastProducts());
        expect(result, equals(Result.success(data: tProducts)));
      });
      test(
          'Should return cache failure when there is no cached data is present',
          () async {
        when(mockLocalDataSource.getLastProducts()).thenThrow(CacheException());

        final result = await repository.getAllProducts();

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastProducts());
        expect(result, equals(Result<List<Product>>.error(error: CacheFailure())));
      });
    });
  });

  group('getProduct', () {
    const int tProductId = 1;
    final ProductModel tProductModel = ProductModel(
        id: 1,
        title: 'title',
        price: 100,
        description: 'description',
        category: 'category',
        image: 'image');
    final Product tProduct = tProductModel;

    test('should check if the device is online', () {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((realInvocation) async => true);
      when(mockRemoteDataSource.getProduct(id: anyNamed('id')))
          .thenAnswer((realInvocation) async => tProductModel);
      repository.getProduct(id: tProductId);
      verify(mockNetworkInfo.isConnected);
    });

    runTestOnline(() {
      test(
          'should return the remote data when the call to remote data is successful',
          () async {
        when(mockRemoteDataSource.getProduct(id: anyNamed('id')))
            .thenAnswer((realInvocation) async => tProductModel);
        final result = await repository.getProduct(id: tProductId);

        verify(mockRemoteDataSource.getProduct(id: tProductId));
        expect(result, equals(Result.success(data: tProduct)));
      });

      test(
          'should cache the data locally when the call to remote data is successful',
          () async {
        when(mockRemoteDataSource.getProduct(id: anyNamed('id')))
            .thenAnswer((realInvocation) async => tProductModel);
        await repository.getProduct(id: tProductId);

        verify(mockRemoteDataSource.getProduct(id: tProductId));
        verify(mockLocalDataSource.cacheProduct(product: tProductModel));
      });

      test(
          'should return server failure when the call to remote data is unsuccessful',
          () async {
        when(mockRemoteDataSource.getProduct(id: anyNamed('id')))
            .thenThrow(ServerException());
        final result = await repository.getProduct(id: tProductId);

        verify(mockRemoteDataSource.getProduct(id: tProductId));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Result<Product>.error(error: ServerFailure())));
      });
    });

    runTestOffline(() {
      test(
          'Should return last locally cached data when the cached data is present',
          () async {
        when(mockLocalDataSource.getCachedProduct(id: anyNamed('id')))
            .thenAnswer((realInvocation) async => tProductModel);

        final result = await repository.getProduct(id: tProductId);

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getCachedProduct(id: tProductId));
        expect(result, equals(Result.success(data: tProduct)));
      });
      test(
          'Should return cache failure when there is no cached data is present',
          () async {
        when(mockLocalDataSource.getCachedProduct(id: anyNamed('id')))
            .thenThrow(CacheException());

        final result = await repository.getProduct(id: tProductId);

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getCachedProduct(id: tProductId));
        expect(result, equals(Result<Product>.error(error: CacheFailure())));
      });
    });
  });
}
