import 'package:flutter/material.dart';
import 'package:flutter_app_starter/products/presentation/widgets/products_list_view.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: const ProductsListView(),appBar: AppBar(),);
  }
}
