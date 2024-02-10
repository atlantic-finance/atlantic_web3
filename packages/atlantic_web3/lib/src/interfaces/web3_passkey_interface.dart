
import 'package:atlantic_web3/atlantic_web3.dart';

abstract interface class IWeb3Passkey {
  IMnemonic generateMnemonic({int length, Language language});

  EthPassKey createEthPassKey(IMnemonic mnemonic, String passphrase);
  IBIP32 createDerivateEthPassKey(IMnemonic mnemonic, String passphrase);

  Future<EthPassKey> saveEthPasskey(String documentId, String name, EthPassKey passKey, String passPhrase);
  Future<EthPassKey> setDefaultEthPasskey(String passKeyID, String passPhrase);
  Future<Void> deleteEthPasskey(String passkeyID);

  Future<EthPassKey> getDefaultEthPasskey(String passPhrase);
  Future<EthPassKey> getEthPasskey(String passKeyID, String passPhrase);
  Future<List<EthPassKey>> getAllEthPasskey(String passPhrase);

}
