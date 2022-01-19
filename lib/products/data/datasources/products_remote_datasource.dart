import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_app_starter/core/error/exceptions.dart';
import 'package:flutter_app_starter/core/network/dio_client.dart';
import 'package:flutter_app_starter/products/data/models/product_model.dart';
import 'package:retrofit/http.dart';

part 'products_remote_datasource.g.dart';

abstract class ProductsRemoteDataSource {
  Future<List<ProductModel>> getProducts();

  Future<ProductModel> getProduct({required int id});
}

class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  DioClient dioClient;

  ProductsRemoteDataSourceImpl(this.dioClient);

  @override
  Future<ProductModel> getProduct({required int id}) async {
    final Response response = await dioClient
        .get('https://fakestoreapi.com/products/$id') as Response;
    if (response.statusCode == 200) {
      return ProductModel.fromJson(
          json.decode(response.data.toString()) as Map<String, dynamic>);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<ProductModel>> getProducts() async {
    final Response response = await dioClient.get('products');
    if (response.statusCode == 200) {
      return List<ProductModel>.from(json
          .decode(response.data.toString())
          .map((item) => ProductModel.fromJson(item))).toList();
    } else {
      throw ServerException();
    }
  }
}

@RestApi()
abstract class ProductRemoteDataSourceRetrofitImpl
    implements ProductsRemoteDataSource {
  factory ProductRemoteDataSourceRetrofitImpl(Dio dio, {String baseUrl}) =
      _ProductRemoteDataSourceRetrofitImpl;

  @override
  @GET('products/{id}')
  Future<ProductModel> getProduct({required int id});

  @override
  @GET('produc')
  Future<List<ProductModel>> getProducts();
}
