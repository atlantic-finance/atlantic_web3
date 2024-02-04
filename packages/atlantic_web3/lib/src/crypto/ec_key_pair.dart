
import 'dart:typed_data';

import 'package:atlantic_web3/atlantic_web3.dart';
import 'package:hex/hex.dart';


class ECKeyPair {
  late Uint8List _seed;
  late BigInteger _privateKey;
  late BigInteger _publicKey;

  ECKeyPair.create(Uint8List seed) {
    _seed = seed;
    _privateKey = _privateKeyFromSeed(seed);
    _publicKey = _publicKeyFromSeed(seed);
  }

  BigInteger get publicKey => _publicKey;

  BigInteger get privateKey => _privateKey;

  Uint8List get bytes => _seed;

  String get hex => HEX.encode(_seed).toString();

  BigInteger _publicKeyFromSeed(Uint8List bytes) {
    final BigInteger privateKeyInt = bytesToUnsignedInt(bytes);

    final Uint8List encoder = privateKeyToPublic(privateKeyInt);

    return bytesToUnsignedInt(encoder);
  }

  BigInteger _privateKeyFromSeed(Uint8List bytes) {
    return bytesToUnsignedInt(bytes);
  }
}
