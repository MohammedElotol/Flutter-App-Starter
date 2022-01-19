import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;

  const Product(this.id, this.title, this.price, this.description,
      this.category, this.image);

  @override
  List<Object?> get props => [id, title, price, description, category, image];
}
