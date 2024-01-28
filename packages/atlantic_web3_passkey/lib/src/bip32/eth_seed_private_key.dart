import 'package:atlantic_web3/atlantic_web3.dart';
import 'package:crypto/crypto.dart';

class EthSeedPrivateKey implements IBIP32 {
  final Digest _digest;

  EthSeedPrivateKey(this._digest);

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