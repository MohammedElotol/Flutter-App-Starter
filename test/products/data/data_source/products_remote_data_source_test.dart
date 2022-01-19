import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_app_starter/core/error/exceptions.dart';
import 'package:flutter_app_starter/core/network/dio_client.dart';
import 'package:flutter_app_starter/products/data/datasources/products_remote_datasource.dart';
import 'package:flutter_app_starter/products/data/models/product_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/fixture_reader.dart';
import 'products_remote_data_source_test.mocks.dart';

@GenerateMocks([DioClient])
main() {
  late MockDioClient mockDioClient;
  late ProductsRemoteDataSourceImpl dataSource;

  setUp(() {
    mockDioClient = MockDioClient();
    dataSource = ProductsRemoteDataSourceImpl(mockDioClient);
  });

  void stubDioClientSuccess() {
    when(mockDioClient.get(any)).thenAnswer((realInvocation) async => Response(
        requestOptions: RequestOptions(path: ''),
        data: fixture('product_double_price.json'),
        statusCode: 200));
  }

  void stubDioClientFailure404() {
    when(mockDioClient.get(any)).thenAnswer((realInvocation) async => Response(
        requestOptions: RequestOptions(path: ''),
        data: 'Something went wrong',
        statusCode: 404));
  }

  group('getProduct', () {
    const int tId = 1;
    final ProductModel tProductModel = ProductModel.fromJson(json
        .decode(fixture('product_double_price.json')) as Map<String, dynamic>);

    test('Should perform a GET request on a url with the id of the product',
        () async {
      stubDioClientSuccess();

      dataSource.getProduct(id: tId);
      verify(mockDioClient.get('https://fakestoreapi.com/products/$tId'));
    });

    test('Should return ProductModel when the response code is 200 (success)',
        () async {
      stubDioClientSuccess();
      final result = await dataSource.getProduct(id: tId);
      expect(result, equals(tProductModel));
    });

    test(
        'Should throw a server exception when the response code is 404 or other server orror',
        () async {
      stubDioClientFailure404();
      expect(dataSource.getProduct(id: tId), throwsA(isA<ServerException>()));
    });
  });

  group('getProducts', () {
    final Iterable iterable = json.decode(fixture('products.json'));
    final List<ProductModel> tProductModels = List<ProductModel>.from(iterable
        .map((item) => ProductModel.fromJson(item)))
        .toList();

    // test('Should perform a GET request on a url of the products',
    //         () async {
    //           when(mockDioClient.get(any)).thenAnswer((realInvocation) async => Response(
    //               requestOptions: RequestOptions(path: ''),
    //               data: fixture('products.json'),
    //               statusCode: 200));
    //
    //       dataSource.getProducts();
    //       verify(mockDioClient.get('https://fakestoreapi.com/products'));
    //     });

    test('Should return List of ProductModel when the response code is 200 (success)',
            () async {
              when(mockDioClient.get(any)).thenAnswer((realInvocation) async => Response(
                  requestOptions: RequestOptions(path: ''),
                  data: fixture('products.json'),
                  statusCode: 200));
          final result = await dataSource.getProducts();
          expect(result, equals(tProductModels));
        });

    test(
        'Should throw a server exception when the response code is 404 or other server orror',
            () async {
          stubDioClientFailure404();
          expect(dataSource.getProducts(), throwsA(isA<ServerException>()));
        });
  });
}
