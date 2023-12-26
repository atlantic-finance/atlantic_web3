
import 'package:atlantic_web3_core/atlantic_web3_core.dart';

abstract interface class IWeb3Passkey {
  IBIP39 generateMnemonic({int length = 12});
  EthPrivateKey createPrivateKey(IBIP39 nnemonic);
  IBIP32 createDerivatePrivateKey(IBIP39 nnemonic, String passphrase);
}
