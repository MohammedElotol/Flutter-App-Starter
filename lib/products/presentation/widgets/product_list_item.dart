import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_starter/products/domain/entities/product.dart';
import 'package:flutter_app_starter/products/presentation/presenters/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductListItem extends ConsumerWidget {
  const ProductListItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Product product = ref.watch(shortProductProvider);
    return InkWell(
      onTap: () {},
      child: Card(
        child: Column(
          children: [Text(product.title), Text(product.category)],
        ),
      ),
    );
  }
}
