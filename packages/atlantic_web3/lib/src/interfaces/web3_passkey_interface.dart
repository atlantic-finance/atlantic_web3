
import 'package:atlantic_web3/atlantic_web3.dart';

abstract interface class IWeb3Passkey {
  Boolean get isAuthenticate;
  set inMemoryPassPhrase(String? passPhrase);

  IMnemonic generateMnemonic({int length, Language language});

  EthPassKey createEthPassKey(IMnemonic mnemonic, String passPhrase);
  IBIP32 createDerivateEthPassKey(IMnemonic mnemonic, String passPhrase);

  Future<EthPassKey> saveEthPasskey(String documentId, String name, EthPassKey passKey, String passPhrase);
  Future<EthPassKey> setCurrentEthPasskey(String passKeyID, String passPhrase);
  Future<Void> deleteEthPasskey(String passkeyID);

  Future<EthPassKey> getCurrentEthPassKey(String passPhrase);
  Future<EthPassKey> getInMemoryCurrentEthPassKey();
  Future<EthPassKey> getEthPasskey(String passKeyID, String passPhrase);
  Future<List<EthPassKey>> getAllEthPasskey(String passPhrase);

}
