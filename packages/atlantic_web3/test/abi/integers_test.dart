import 'package:atlantic_web3/atlantic_web3.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils.dart';

void main() {
  group('encodes', () {
    test('negative int32 values', () {
      const type = IntType(length: 32);
      expectEncodes(type, BigInt.from(-200), '${'f' * 62}38');
    });
  });

  group('decodes', () {
    test('negative int32 values', () {
      const type = IntType(length: 32);
      final decoded = type.decode(bufferFromHex('${'f' * 62}38'), 0);
      expect(decoded.bytesRead, 32);
      expect(decoded.data, BigInt.from(-200));
    });
  });
}
