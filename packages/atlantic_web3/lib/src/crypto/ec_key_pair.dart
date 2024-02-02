
import 'dart:typed_data';

import 'package:atlantic_web3/atlantic_web3.dart';
import 'package:hex/hex.dart';


class ECKeyPair {
  late List<int> _seed;
  late BigInteger _privateKey;
  late BigInteger _publicKey;

  ECKeyPair.create(List<int> seed) {
    _seed = seed;
    _privateKey = _privateKeyFromSeed(seed);
    _publicKey = _publicKeyFromSeed(seed);
  }

  BigInteger get publicKey => _publicKey;

  BigInteger get privateKey => _privateKey;

  List<int> get bytes => _seed;

  String get hex => HEX.encode(_seed).toString();

  BigInteger _publicKeyFromSeed(List<int> bytes) {
    final BigInteger privateKeyInt = bytesToUnsignedInt(bytes as Uint8List);

    final List<int> encoder = privateKeyToPublic(privateKeyInt);

    return bytesToUnsignedInt(encoder as Uint8List);
  }

  BigInteger _privateKeyFromSeed(List<int> bytes) {
    return bytesToUnsignedInt(bytes as Uint8List);
  }
}
