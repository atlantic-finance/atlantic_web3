
import 'dart:core';
import 'dart:io';

import 'package:atlantic_web3/atlantic_web3.dart';
import 'package:atlantic_web3_passkey/atlantic_web3_passkey.dart';

class Web3Passkey implements IWeb3Passkey {
  // Instancia privada
  static Web3Passkey? _instance = null;

  static IWeb3Passkey instance() {
    if (_instance == null) {
      _instance = Web3Passkey._();
    }
    return _instance!;
  }

  late final EthBip39Generator bip39;

  Web3Passkey._() {
    bip39 = EthBip39Generator();
  }

  /// Permite generar frases mnemonic dependiendo el lenguaje y longitud, tambien
  /// debe tomar en cuenta el id del dispositivo para usarlo como una entropy inicial
  /// para que sea de manera unica y aleatoria. La longitud de la frases se de determina
  /// por la siguiente tabla:
  ///
  /// ---------------------------------
  /// | words length | entropy length |
  /// ---------------------------------
  /// | 12           | 128            |
  /// | 15           | 160            |
  /// | 18           | 192            |
  /// | 21           | 224            |
  /// | 24           | 256            |
  /// ---------------------------------
  /// mas informacion <a href="https://github.com/leonardocustodio/polkadart/blob/main/packages/substrate_bip39/lib/crypto_scheme.dart">aqui</a>
  ///
  @override
  Mnemonic generateMnemonic({int length = 12, Language language = Language.english}) {
    final List<String> words = bip39.generateWordsRandomly(length, language);
    assert(
    (words.length % 3) == 0 && words.length >= 12 && words.length <= 32,
    'The words length must be 12, 15, 18, 21 or 24',);
    return Mnemonic.from(words);
  }

  @override
  EthPassKey createEthPassKey(IMnemonic mnemonic, String passphrase) {
    // Semilla
    final List<int> seed = Pbkdf2Helpers.createSeedFromMnemonic(mnemonic, passphrase);

    // Encapsular claves publica y privada
    final ECKeyPair keyPair = ECKeyPair.create(seed);

    // Crear llave de accesos usando las claves
    return EthPassKey.fromKeyPair(keyPair);
  }

  @override
  EthBip32PassKey createDerivateEthPassKey(IMnemonic mnemonic, String passphrase) {
    // Semilla
    final List<int> seed = Pbkdf2Helpers.createSeedFromMnemonic(mnemonic, passphrase);

    // Encapsular claves publica y privada
    final ECKeyPair keyPair = ECKeyPair.create(seed);

    // Crear derivador de llaves de accesos usando las claves
    return EthBip32PassKey.fromKeyPair(keyPair);
  }

  @override
  EthPassKey getDefaultEthPrivateKey() {
    // TODO: implement getDefaultEthPrivateKey
    throw UnimplementedError();
  }

  @override
  IBip39Wallet createBip39Wallet(String password, File destinationDirectory) {
    // TODO: implement createBip39Wallet
    throw UnimplementedError();
  }
}
