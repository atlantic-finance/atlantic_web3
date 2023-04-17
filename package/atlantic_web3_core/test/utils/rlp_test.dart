import 'dart:convert';

import 'package:atlantic_web3_core/atlantic_web3_core.dart';
import 'package:flutter_test/flutter_test.dart';

import 'data/rlp_test_vectors.dart' as data;

void main() {
  final testContent = json.decode(data.content) as Map;

  for (final key in testContent.keys) {
    test('$key', () {
      final data = testContent[key];
      final input = _mapTestData(data['in']);
      final output = data['out'] as String;

      expect(bytesToHex(encode(input), include0x: true), output);
    });
  }
}

dynamic _mapTestData(dynamic data) {
  if (data is String && data.startsWith('#')) {
    return BigInt.parse(data.substring(1));
  }

  return data;
}
