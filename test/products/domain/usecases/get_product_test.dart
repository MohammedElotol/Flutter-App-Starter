import 'package:flutter_app_starter/core/states/result.dart';
import 'package:flutter_app_starter/products/domain/entities/product.dart';
import 'package:flutter_app_starter/products/domain/repositories/products_repository.dart';
import 'package:flutter_app_starter/products/domain/usecases/get_product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'get_all_products_test.mocks.dart';

@GenerateMocks([ProductsRepository])
main() async {
  late GetProduct useCase;
  late MockProductsRepository mockProductsRepository;

  setUp(() {
    mockProductsRepository = MockProductsRepository();
    useCase = GetProduct(mockProductsRepository);
  });

  const tProduct = Product(1, 'title', 100, 'description', 'category', 'image');

  test('should get a product form the repository', () async {
    const actual = Result.success(data: tProduct);
    when(mockProductsRepository.getProduct(id: anyNamed('id')))
        .thenAnswer((realInvocation) async => actual);

    final result = await useCase(Params(productId: tProduct.id));
    expect(result, actual);
    verify(mockProductsRepository.getProduct(id: tProduct.id));
    verifyNoMoreInteractions(mockProductsRepository);
  });
}
