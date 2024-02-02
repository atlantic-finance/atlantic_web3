
import 'dart:io';

import 'package:atlantic_web3/atlantic_web3.dart';

abstract interface class IWeb3Passkey {
  IMnemonic generateMnemonic({int length, Language language});
  EthPassKey createEthPassKey(IMnemonic mnemonic, String passphrase);
  IBIP32 createDerivateEthPassKey(IMnemonic mnemonic, String passphrase);



  EthPassKey getDefaultEthPrivateKey();
  IBip39Wallet createBip39Wallet(String password, File destinationDirectory);
}
