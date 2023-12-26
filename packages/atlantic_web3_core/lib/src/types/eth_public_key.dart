import 'dart:typed_data';

import 'package:atlantic_web3_core/atlantic_web3_core.dart';
import 'package:pointycastle/ecc/api.dart' show ECPoint;

class EthPublicKey {
  final BigInt privateKeyInt;
  final Uint8List privateKey;


  EthPublicKey(this.privateKeyInt, this.privateKey);

  /// Get the encoded public key in an (uncompressed) byte representation.
  Uint8List get encodedPublicKey => privateKeyToPublic(privateKeyInt);

  /// The public key corresponding to this private key.
  ECPoint get publicKey => (params.G * privateKeyInt)!;
}
