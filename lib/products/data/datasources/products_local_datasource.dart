import 'dart:convert';

import 'package:flutter_app_starter/core/error/exceptions.dart';
import 'package:flutter_app_starter/products/data/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ProductsLocalDataSource {
  ///Gets the cached list of [ProductModel] which was gotten the last time
  ///the user had an Internet connection
  ///Throws [CacheException] if no cached data is present.
  Future<List<ProductModel>> getLastProducts();

  Future<void> cacheProducts({required List<ProductModel> products});

  Future<ProductModel> getCachedProduct({required int id});

  Future<void> cacheProduct({required ProductModel product});
}

const String perfCachedProducts = 'CACHED_PRODUCTS';

class ProductsLocalDataSourceImpl implements ProductsLocalDataSource {
  final SharedPreferences sharedPreferences;

  ProductsLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheProduct({required ProductModel product}) {
    final String jsonString = json.encode(product.toJson());
    return sharedPreferences.setString(
        'product_${product.id}', jsonString);
  }

  @override
  Future<void> cacheProducts({required List<ProductModel> products}) {
    return sharedPreferences.setString(perfCachedProducts,
        products.map((e) => json.encode(e.toJson())).toString());
  }

  @override
  Future<ProductModel> getCachedProduct({required int id}) {
    final String? productJsonString = sharedPreferences.getString('product_$id');
    if(productJsonString != null) {
      ProductModel productModel = ProductModel.fromJson(
          json.decode(productJsonString) as Map<String, dynamic>);
      return Future.value(productModel);
    }else{
      throw CacheException();
    }
  }

  @override
  Future<List<ProductModel>> getLastProducts() {
    final String? jsonString = sharedPreferences.getString(perfCachedProducts);
    if (jsonString != null) {
      final Iterable iterable = json.decode(jsonString) as Iterable;
      final List<ProductModel> cachedProducts = List<ProductModel>.from(
          iterable.map((item) =>
              ProductModel.fromJson(item as Map<String, dynamic>))).toList();
      return Future.value(cachedProducts);
    } else {
      throw CacheException();
    }
  }
}
