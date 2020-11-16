import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Simple test', () {
    String str = 'test';

    str.toUpperCase();

    expect(str, 'TEST');
  });
}