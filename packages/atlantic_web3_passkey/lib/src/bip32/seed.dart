import 'package:atlantic_web3/atlantic_web3.dart';
import 'package:atlantic_web3_core/atlantic_web3_core.dart';
import 'package:crypto/crypto.dart';

abstract class IBIP32 {
  String toHex();

  List<int> toBytes();

  EthPrivateKey toPrivateKey();
}

class Seed implements IBIP32 {
  final Digest _digest;

  Seed(this._digest);

  @override
  String toHex() {
    return _digest.toString();
  }

  @override
  List<int> toBytes() {
    return _digest.bytes;
  }

  @override
  EthPrivateKey toPrivateKey() {
    return EthPrivateKey.fromHex(_digest.toString());
  }
}
