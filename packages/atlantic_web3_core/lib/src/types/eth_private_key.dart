import 'dart:math';
import 'dart:typed_data';

import 'package:atlantic_web3_core/atlantic_web3_core.dart';
import 'package:atlantic_web3_core/src/crypto/secp256k1.dart' as secp256k1;
import 'package:atlantic_web3_core/src/utils/equality.dart' as eq;
import 'package:pointycastle/ecc/api.dart' show ECPoint;

/// Credentials that can sign payloads with an Ethereum private key.
class EthPrivateKey extends CredentialsWithKnownAddress {
  /// Creates a private key from a byte array representation.
  ///
  /// The bytes are interpreted as an unsigned integer forming the private key.
  EthPrivateKey(this.privateKey)
      : privateKeyInt = bytesToUnsignedInt(privateKey);

  /// Parses a private key from a hexadecimal representation.
  EthPrivateKey.fromHex(String hex) : this(hexToBytes(hex));

  /// Creates a private key from the underlying number.
  EthPrivateKey.fromInt(this.privateKeyInt)
      : privateKey = unsignedIntToBytes(privateKeyInt);

  /// Creates a new, random private key from the [random] number generator.
  ///
  /// For security reasons, it is very important that the random generator used
  /// is cryptographically secure. The private key could be reconstructed by
  /// someone else otherwise. Just using [Random()] is a very bad idea! At least
  /// use [Random.secure()].
  factory EthPrivateKey.createRandom(Random random) {
    final key = generateNewPrivateKey(random);
    return EthPrivateKey(intToBytes(key));
  }

  /// ECC's d private parameter.
  final BigInt privateKeyInt;
  final Uint8List privateKey;
  EthAddress? _cachedAddress;

  @override
  final bool isolateSafe = true;

  @override
  EthAddress get address {
    return _cachedAddress ??=
        EthAddress(publicKeyToAddress(privateKeyToPublic(privateKeyInt)));
  }

  /// Get the encoded public key in an (uncompressed) byte representation.
  Uint8List get encodedPublicKey => privateKeyToPublic(privateKeyInt);

  /// The public key corresponding to this private key.
  ECPoint get publicKey => (params.G * privateKeyInt)!;

  @Deprecated('Please use [signToSignatureSync]')
  @override
  Future<MsgSignature> signToSignature(
    Uint8List payload, {
    int? chainId,
    bool isEIP1559 = false,
  }) async {
    final signature = secp256k1.sign(keccak256(payload), privateKey);

    // https://github.com/ethereumjs/ethereumjs-util/blob/8ffe697fafb33cefc7b7ec01c11e3a7da787fe0e/src/signature.ts#L26
    // be aware that signature.v already is recovery + 27
    int chainIdV;
    if (isEIP1559) {
      chainIdV = signature.v - 27;
    } else {
      chainIdV = chainId != null
          ? (signature.v - 27 + (chainId * 2 + 35))
          : signature.v;
    }
    return MsgSignature(signature.r, signature.s, chainIdV);
  }

  @override
  MsgSignature signToEcSignature(
    Uint8List payload, {
    int? chainId,
    bool isEIP1559 = false,
  }) {
    final signature = secp256k1.sign(keccak256(payload), privateKey);

    // https://github.com/ethereumjs/ethereumjs-util/blob/8ffe697fafb33cefc7b7ec01c11e3a7da787fe0e/src/signature.ts#L26
    // be aware that signature.v already is recovery + 27
    int chainIdV;
    if (isEIP1559) {
      chainIdV = signature.v - 27;
    } else {
      chainIdV = chainId != null
          ? (signature.v - 27 + (chainId * 2 + 35))
          : signature.v;
    }
    return MsgSignature(signature.r, signature.s, chainIdV);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EthPrivateKey &&
          runtimeType == other.runtimeType &&
          eq.equals(privateKey, other.privateKey);

  @override
  int get hashCode => privateKey.hashCode;
}
