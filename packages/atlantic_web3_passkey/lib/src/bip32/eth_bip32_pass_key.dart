import 'dart:typed_data';

import 'package:atlantic_web3/atlantic_web3.dart';
import 'package:crypto/crypto.dart';

class EthBip32PassKey implements IBIP32 {
  late final Digest _digest;


  EthBip32PassKey(this._digest);

  EthBip32PassKey.fromKeyPair(ECKeyPair keyPair) {
    _digest = Digest([] as Uint8List);
  }

  @override
  String toHex() {
    return _digest.toString();
  }

  @override
  List<int> toBytes() {
    return _digest.bytes;
  }

  @override
  EthPassKey toMainPassKey() {
    return EthPassKey.fromHex(_digest.toString());
  }
}
