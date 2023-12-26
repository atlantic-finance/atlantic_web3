import 'dart:typed_data';

import 'package:atlantic_web3_core/atlantic_web3_core.dart';
import 'package:atlantic_web3_core/src/crypto/secp256k1.dart' as secp256k1;
import 'package:atlantic_web3_core/src/utils/equality.dart' as eq;


/// Credenciales que pueden firmar cargas útiles con una clave privada de Ethereum.
final class EthPrivateKey extends CredentialsWithKnownAddress {
  /// Creates a private key from a byte array representation.
  ///
  /// The bytes are interpreted as an unsigned integer forming the private key.
  EthPrivateKey(this.hex, this.privateKey)
      : privateKeyInt = bytesToUnsignedInt(privateKey);

  /// Parses a private key from a hexadecimal representation.
  EthPrivateKey.fromHex(String hex) : this(hex, hexToBytes(hex));

  /// Creates a private key from the underlying number.
  // EthPrivateKey.fromInt(this.privateKeyInt) {
  //   this.privateKey = unsignedIntToBytes(privateKeyInt);
  //   this.hex = bytesToHex(privateKey as List<int>);
  // }


  /// ECC's d private parameter.
  final BigInt privateKeyInt;
  final Uint8List privateKey;
  final String hex;

  @override
  final bool isolateSafe = true;

  @override
  EthAddress getEthAddress() {
    return EthAddress(publicKeyToAddress(privateKeyToPublic(privateKeyInt)));
  }

  @override
  EthPublicKey getEthPublicKey() {
    return EthPublicKey(privateKeyInt, privateKey);
  }

  @override
  String toHex() {
    return hex;
  }

  @override
  List<int> toBytes() {
    return privateKey;
  }

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
  MsgSignature signToEcSignature(Uint8List payload, {int? chainId, bool isEIP1559 = false,}) {
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
