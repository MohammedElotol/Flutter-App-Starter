import 'dart:convert';

import 'package:flutter_app_starter/core/error/exceptions.dart';
import 'package:flutter_app_starter/products/data/datasources/products_local_datasource.dart';
import 'package:flutter_app_starter/products/data/models/product_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../fixtures/fixture_reader.dart';
import 'Products_local_data_source_test.mocks.dart';

@GenerateMocks([SharedPreferences])
main() {
  late MockSharedPreferences mockSharedPreferences;
  late ProductsLocalDataSourceImpl localDataSource;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    localDataSource =
        ProductsLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  group('getLastProducts', () {
    final String tCachedProductsString = fixture('products_cached.json');
    final Iterable iterable = json.decode(tCachedProductsString) as Iterable;
    final List<ProductModel> tCachedProducts = List<ProductModel>.from(iterable
            .map((item) => ProductModel.fromJson(item as Map<String, dynamic>)))
        .toList();

    test(
        'Should return products from sharedPreferences when there is one in the cache.',
        () async {
      when(mockSharedPreferences.getString(any))
          .thenReturn(tCachedProductsString);

      final result = await localDataSource.getLastProducts();
      verify(mockSharedPreferences.getString(perfCachedProducts));
      expect(result, tCachedProducts);
    });

    test('Should throw a CacheException when there is not a cached value.',
        () async {
      when(mockSharedPreferences.getString(any)).thenReturn(null);

      final call = localDataSource.getLastProducts;
      expect(() => call(), throwsA(isA<CacheException>()));
    });
  });

  group('cacheProducts', () {
    final List<ProductModel> products = [
      ProductModel(
          id: 1,
          title: 'title',
          price: 100,
          description: 'description',
          category: 'category',
          image: 'image')
    ];
    test('Should call SharedPreferences to cache the products.', () {
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((realInvocation) async => true);
      localDataSource.cacheProducts(products: products);
      final expectedJsonString =
          products.map((e) => json.encode(e.toJson())).toString();
      verify(mockSharedPreferences.setString(
          perfCachedProducts, expectedJsonString));
    });
  });

  group('getCachedProduct', () {
    final ProductModel tCachedProduct = ProductModel.fromJson(
        json.decode(fixture('product_cached.json')) as Map<String, dynamic>);
    const int tId = 1;
    test(
        'Should return a product from sharedPreferences when it is already cached.',
        () async {
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixture('product_cached.json'));

      final result = await localDataSource.getCachedProduct(id: tId);
      verify(mockSharedPreferences.getString('product_$tId'));
      expect(result, tCachedProduct);
    });

    test(
        'Should throw a CacheException when there is not a cached value for the specified product.',
        () async {
      when(mockSharedPreferences.getString(any)).thenReturn(null);

      expect(() => localDataSource.getCachedProduct(id: tId),
          throwsA(isA<CacheException>()));
    });
  });

  group('cacheProduct', () {
    final ProductModel product = ProductModel(
        id: 1,
        title: 'title',
        price: 100,
        description: 'description',
        category: 'category',
        image: 'image');
    test('Should call SharedPreferences to cache the product.', () {
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((realInvocation) async => true);
      localDataSource.cacheProduct(product: product);
      final expectedJsonString = json.encode(product.toJson());
      verify(mockSharedPreferences.setString(
          'product_${product.id}', expectedJsonString));
    });
  });
}
