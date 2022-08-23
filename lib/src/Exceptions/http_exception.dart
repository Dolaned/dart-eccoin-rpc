class HTTPException implements Exception {
  int code;
  String message;

  HTTPException({required this.code, required this.message});

  @override
  String toString() {
    return '$code: $message';
  }
}
