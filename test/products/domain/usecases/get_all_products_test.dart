import 'package:flutter_app_starter/core/domain/usecases/use_case.dart';
import 'package:flutter_app_starter/core/states/result.dart';
import 'package:flutter_app_starter/products/domain/entities/product.dart';
import 'package:flutter_app_starter/products/domain/repositories/products_repository.dart';
import 'package:flutter_app_starter/products/domain/usecases/get_all_products.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'get_all_products_test.mocks.dart';


@GenerateMocks([ProductsRepository])
main() async {
  late GetProducts useCase;
  late MockProductsRepository mockProductsRepository;

  setUp(() {
    mockProductsRepository = MockProductsRepository();
    useCase = GetProducts(mockProductsRepository);
  });

  final tProducts = [
    const Product(1, 'title', 100, 'description', 'category', 'image')
  ];

  test('should get all products form the repository', () async {
    when(mockProductsRepository.getAllProducts()).thenAnswer(
        (realInvocation) async => Result.success(data: tProducts));

    final result = await useCase(const NoParams());
    expect(result, Result.success(data: tProducts));
    verify(mockProductsRepository.getAllProducts());
    verifyNoMoreInteractions(mockProductsRepository);
  });
}

