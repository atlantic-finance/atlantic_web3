import 'package:atlantic_web3/atlantic_web3.dart';

abstract interface class IBIP39 {
  List<String> getWords();
  StringBuffer getStringBuffer();
}

abstract interface class IBIP32 {
  String toHex();

  List<int> toBytes();

  EthPrivateKey toPrivateKey();
}

abstract interface class IBip39Wallet {

}
