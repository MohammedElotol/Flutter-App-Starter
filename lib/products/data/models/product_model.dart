import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_app_starter/products/domain/entities/product.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel extends Product{

  const ProductModel(
      {required int id,
      required String title,
      required double price,
      required String description,
      required String category,
      required String image})
      : super(id, title, price, description, category, image);

  factory ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}