import 'dart:typed_data';

import 'package:atlantic_web3/atlantic_web3.dart';
import 'package:atlantic_web3/src/crypto/secp256k1.dart' as secp256k1;
import 'package:atlantic_web3/src/utils/equality.dart' as eq;


/// Credenciales que pueden firmar cargas útiles con una clave privada de Ethereum.
final class EthPassKey extends PasskeyWithKnownAccount {

  EthPassKey.fromInt(BigInt keyInt) : this.fromBytes(unsignedIntToBytes(keyInt));

  EthPassKey.fromHex(String hex) : this.fromBytes(hexToBytes(hex));

  EthPassKey.fromBytes(Uint8List bytes) : this.fromKeyPair(ECKeyPair.create(bytes));

  EthPassKey.fromKeyPair(this._keyPair);


  /// ECC's d private parameter.
  final ECKeyPair _keyPair;


  @override
  final bool isolateSafe = true;

  @override
  EthAccount getEthAccount() {
    return EthAccount(publicKeyToAddress(privateKeyToPublic(_keyPair.privateKey)));
  }

  @override
  EthPublicKey getEthPublicKey() {
    //return EthPublicKey(privateKeyInt, privateKey);
    // TODO: implement getEthPrivateKey
    throw UnimplementedError();
  }

  @override
  EthPrivateKey getEthPrivateKey() {
    // TODO: implement getEthPrivateKey
    throw UnimplementedError();
  }

  @override
  String toHex() {
    return _keyPair.hex;
  }

  @override
  Uint8List toBytes() {
    return _keyPair.bytes;
  }

  @Deprecated('Please use [signToSignatureSync]')
  @override
  Future<MsgSignature> signToSignature(
    Uint8List payload, {
    int? chainId,
    bool isEIP1559 = false,
  }) async {
    final signature = secp256k1.sign(keccak256(payload), _keyPair.bytes);

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
    final signature = secp256k1.sign(keccak256(payload), _keyPair.bytes);

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
      other is EthPassKey &&
          runtimeType == other.runtimeType &&
          eq.equals(toBytes(), other.toBytes());

  @override
  int get hashCode => _keyPair.bytes.hashCode;
}
