import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure([this.message = 'Unexpected Error']);

  @override
  List<Object?> get props => [message];
}
class RemoteFailure extends Failure{
  const RemoteFailure([String message = 'Remote Error']) : super(message);
}
class ServerFailure extends RemoteFailure {
  const ServerFailure([String message = 'Server Error']) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'No Data']) : super(message);
}

class InvalidInputFailure extends Failure {
  const InvalidInputFailure([String message = 'Invalid Input'])
      : super(message);
}

class InternetConnectionFailure extends RemoteFailure{
  const InternetConnectionFailure([String message = 'No Internet Connection'])
      : super(message);
}
// class NetworkFailure {
//   dynamic error;
//
//   NetworkFailure(this.error) {
//     _dioExceptions(error);
//   }
//
//   Failure _dioExceptions(dynamic error) {
//     try {
//       if (error is DioError) {
//         switch (error.type) {
//           case DioErrorType.cancel:
//             return Failure('Request Cancelled');
//           case DioErrorType.connectTimeout:
//             return Failure('Connection request timeout');
//           case DioErrorType.other:
//             return Failure('No internet connection');
//           case DioErrorType.receiveTimeout:
//             return Failure('Receive timeout in connection with API server');
//           case DioErrorType.response:
//             return _handleResponse(error.response!.statusCode!);
//           case DioErrorType.sendTimeout:
//             return Failure('Send timeout in connection with API server');
//         }
//       } else if (error is SocketException) {
//         return Failure('No internet connection');
//       } else {
//         return Failure('Unexpected error occurred');
//       }
//     } on FormatException {
//       // Helper.printError(e.toString());
//       return Failure('Unexpected error occurred');
//     } catch (_) {
//       return Failure('Unexpected error occurred');
//     }
//   }
//
//   Failure _handleResponse(int statusCode) {
//     switch (statusCode) {
//       case 400:
//       case 401:
//       case 403:
//         return Failure('Unauthorized request');
//       case 404:
//         return Failure('Not Found');
//       case 409:
//         return Failure('Error due to a conflict');
//       case 408:
//         return Failure('Connection request timeout');
//       case 500:
//         return Failure('Internal Server Error');
//       case 503:
//         return Failure('Service unavailable');
//       default:
//         var responseCode = statusCode;
//         return Failure('Received invalid status code: $responseCode');
//     }
//   }
// }
