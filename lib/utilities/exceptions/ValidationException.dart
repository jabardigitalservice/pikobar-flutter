class ValidationException implements Exception {

  final Map<String, dynamic> errors;

  const ValidationException([this.errors]);

  String toString() => "ValidationException";
}