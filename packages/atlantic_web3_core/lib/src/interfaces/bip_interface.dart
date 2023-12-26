import 'package:atlantic_web3_core/atlantic_web3_core.dart';

abstract interface class IBIP39 {
  List<String> getWords();
  StringBuffer getStringBuffer();
}

abstract class IBIP32 {
  String toHex();

  List<int> toBytes();

  EthPrivateKey toPrivateKey();
}
