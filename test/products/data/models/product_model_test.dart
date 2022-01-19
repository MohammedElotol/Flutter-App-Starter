import 'dart:convert';

import 'package:flutter_app_starter/products/data/models/product_model.dart';
import 'package:flutter_app_starter/products/domain/entities/product.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/fixture_reader.dart';

main() {
  final tProductModel = ProductModel(
      id: 1,
      title: "Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops",
      price: 109.0,
      description:
          "Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday",
      category: "men's clothing",
      image: "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg");
  test('Should be a subclass of Product Entity', () {
    expect(tProductModel, isA<Product>());
  });

  group('fromJson', () {
    test('Should return a valid Product model when price is an Integer', () {
      final Map<String, dynamic> productMap = json
          .decode(fixture('product_int_price.json')) as Map<String, dynamic>;
      final result = ProductModel.fromJson(productMap);
      expect(result, tProductModel);
    });

    test('Should return a valid Product model when price is a double', () {
      final Map<String, dynamic> productMap = json
          .decode(fixture('product_double_price.json')) as Map<String, dynamic>;
      final result = ProductModel.fromJson(productMap);
      expect(result, tProductModel);
    });
  });

  group('toJson', (){
    test('Should return a valid json map containing product data', (){
      final Map<String, dynamic> map = tProductModel.toJson();
      final expectedMap = {
        "id": 1,
        "title": "Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops",
        "price": 109.0,
        "description": "Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday",
        "category": "men's clothing",
        "image": "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg"
      };
      expect(expectedMap, map);
    });
  });
}
