import 'dart:typed_data';

extension Uint8ListExtensions on Uint8List {
  String toBinary() {
    return map((byte) => byte
            .toRadixString(2) // Convert byte to binary
            .padLeft(8, '0') // Make sure it is 8
        ).join('');
  }

  // TODO: Implement the case if the length is different
  Uint8List xor(Uint8List b) {
    if (length != b.length) {
      throw ArgumentError.value("It should have the same length");
    }

    Uint8List c = Uint8List(length);
    for (var i = 0; i < length; i++) {
      c[i] = elementAt(i) ^ b.elementAt(i);
    }
    return c;
  }
}

extension IntListExtensions on List<int> {
  String toBinary() {
    return map((byte) => byte
            .toRadixString(2) // Convert byte to binary
            .padLeft(8, '0') // Make sure it is 8
        ).join('');
  }
}
