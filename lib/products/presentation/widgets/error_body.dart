import 'package:flutter/cupertino.dart';

class ErrorBody extends StatelessWidget {
  final String message;

  const ErrorBody({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(message);
  }
}
