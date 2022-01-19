import 'package:flutter/material.dart';
import 'package:flutter_app_starter/products/presentation/presenters/providers.dart';
import 'package:flutter_app_starter/products/presentation/widgets/product_list_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'error_body.dart';

class ProductsListView extends ConsumerWidget {
  const ProductsListView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsState = ref.watch(productsProvider);
    return productsState.when(
      data: (products) => ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) => ProviderScope(
          overrides: [shortProductProvider.overrideWithValue(products[index])],
          child: const ProductListItem(),
        ),
      ),
      error: (error, stackTrace) => ErrorBody(message: error.toString()),
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}
