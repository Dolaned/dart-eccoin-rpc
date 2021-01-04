import 'dart:io';

class HTTPException implements Exception {
  int code;
  String message;

  HTTPException({this.code, this.message});

  @override
  String toString() {
    return '$code: $message';
  }
}
