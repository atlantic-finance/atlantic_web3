
import 'dart:io';

import 'package:atlantic_web3/atlantic_web3.dart';

abstract interface class IWeb3Passkey {
  IBip39Wallet createBip39Wallet(String password, File destinationDirectory);



  IBIP39 generateMnemonic({int length, Language language});
  EthPrivateKey createPrivateKey(IBIP39 nnemonic);
  IBIP32 createDerivatePrivateKey(IBIP39 nnemonic, String passphrase);
  EthPrivateKey getDefaultEthPrivateKey();
}
