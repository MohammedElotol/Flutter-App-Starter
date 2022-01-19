import 'package:flutter_app_starter/core/error/failure.dart';
import 'package:flutter_app_starter/core/states/result.dart';
import 'package:flutter_app_starter/core/util/input_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('StringToInt', () {
    test('Should return an Integer when the string represents integer',
        () {
      const String str = '123';
      final result = inputConverter.stringToInt(str);
      expect(result, const Result.success(data: 123));
    });
    test('Should return a failure when the string is not an integer',
            () {
          const String str = 'abc';
          final result = inputConverter.stringToInt(str);
          expect(result, const Result<int>.error(error: InvalidInputFailure()));
        });
  });

}
