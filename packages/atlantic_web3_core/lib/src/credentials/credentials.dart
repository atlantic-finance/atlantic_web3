import 'dart:convert';
import 'dart:typed_data';

import 'package:atlantic_web3_core/atlantic_web3_core.dart';

/// Anything that can sign payloads with a private key.
abstract class Credentials {
  static const _messagePrefix = '\u0019Ethereum Signed Message:\n';

  /// Whether these [Credentials] are safe to be copied to another isolate and
  /// can operate there.
  /// If this getter returns true, the client might chose to perform the
  /// expensive signing operations on another isolate.
  bool get isolateSafe => false;

  /// Loads the ethereum address specified by these credentials.
  // @Deprecated('Please use [address]')
  // Future<EthAddress> extractAddress();

  //EthAddress get address;

  /// Signs the [payload] with a private key. The output will be like the
  /// bytes representation of the [eth_sign RPC method](https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign),
  /// but without the "Ethereum signed message" prefix.
  /// The [payload] parameter contains the raw data, not a hash.
  @Deprecated('Please use [signToUint8List]')
  Future<Uint8List> sign(
    Uint8List payload, {
    int? chainId,
    bool isEIP1559 = false,
  }) async {
    final signature =
        await signToSignature(payload, chainId: chainId, isEIP1559: isEIP1559);

    final r = padUint8ListTo32(unsignedIntToBytes(signature.r));
    final s = padUint8ListTo32(unsignedIntToBytes(signature.s));
    final v = unsignedIntToBytes(BigInt.from(signature.v));

    // https://github.com/ethereumjs/ethereumjs-util/blob/8ffe697fafb33cefc7b7ec01c11e3a7da787fe0e/src/signature.ts#L63
    return uint8ListFromList(r + s + v);
  }

  /// Signs the [payload] with a private key. The output will be like the
  /// bytes representation of the [eth_sign RPC method](https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign),
  /// but without the "Ethereum signed message" prefix.
  /// The [payload] parameter contains the raw data, not a hash.
  Uint8List signToUint8List(
    Uint8List payload, {
    int? chainId,
    bool isEIP1559 = false,
  }) {
    final signature =
        signToEcSignature(payload, chainId: chainId, isEIP1559: isEIP1559);

    final r = padUint8ListTo32(unsignedIntToBytes(signature.r));
    final s = padUint8ListTo32(unsignedIntToBytes(signature.s));
    final v = unsignedIntToBytes(BigInt.from(signature.v));

    // https://github.com/ethereumjs/ethereumjs-util/blob/8ffe697fafb33cefc7b7ec01c11e3a7da787fe0e/src/signature.ts#L63
    return uint8ListFromList(r + s + v);
  }

  /// Signs the [payload] with a private key and returns the obtained
  /// signature.
  @Deprecated('Please use [signToEcSignature]')
  Future<MsgSignature> signToSignature(
    Uint8List payload, {
    int? chainId,
    bool isEIP1559 = false,
  });

  /// Signs the [payload] with a private key and returns the obtained
  /// signature.
  MsgSignature signToEcSignature(
    Uint8List payload, {
    int? chainId,
    bool isEIP1559 = false,
  });

  /// Signs an Ethereum specific signature. This method is equivalent to
  /// [sign], but with a special prefix so that this method can't be used to
  /// sign, for instance, transactions.
  @Deprecated('Please use [signPersonalMessageToUint8List]')
  Future<Uint8List> signPersonalMessage(Uint8List payload, {int? chainId}) {
    final prefix = _messagePrefix + payload.length.toString();
    final prefixBytes = ascii.encode(prefix);

    // will be a Uint8List, see the documentation of Uint8List.+
    final concat = uint8ListFromList(prefixBytes + payload);

    return sign(concat, chainId: chainId);
  }

  /// Signs an Ethereum specific signature. This method is equivalent to
  /// [signToUint8List], but with a special prefix so that this method can't be used to
  /// sign, for instance, transactions.
  Uint8List signPersonalMessageToUint8List(Uint8List payload, {int? chainId}) {
    final prefix = _messagePrefix + payload.length.toString();
    final prefixBytes = ascii.encode(prefix);

    // will be a Uint8List, see the documentation of Uint8List.+
    final concat = uint8ListFromList(prefixBytes + payload);

    return signToUint8List(concat, chainId: chainId);
  }
}

/// Credentials where the [address] is known synchronously.
abstract class CredentialsWithKnownAddress extends Credentials {
  /// The ethereum address belonging to this credential.
  // @override
  // EthAddress get address;
  //
  // @Deprecated('Please use [address]')
  // @override
  // Future<EthAddress> extractAddress() async {
  //   return Future.value(address);
  // }
  EthAddress getEthAddress();

  EthPublicKey getEthPublicKey();

  String toHex();

  List<int> toBytes();
}

/// Interface for [Credentials] that don't sign transactions locally, for
/// instance because the private key is not known to this library.
abstract class CustomTransactionSender extends Credentials {
  Future<String> sendTransaction(EthTransaction2 transaction);
}
