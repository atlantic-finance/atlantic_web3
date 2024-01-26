
import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:atlantic_web3/atlantic_web3.dart';
import 'package:atlantic_web3_passkey/atlantic_web3_passkey.dart';
import 'package:crypto/crypto.dart';

class Web3Passkey implements IWeb3Passkey {
  // Instancia privada
  static Web3Passkey? _instance = null;

  static IWeb3Passkey instance() {
    if (_instance == null) {
      _instance = Web3Passkey._();
    }
    return _instance!;
  }

  late final Bip32 bip32;
  late final Bip39 bip39;

  Web3Passkey._() {
    bip32 = Bip32();
    bip39 = Bip39();
  }

  @override
  Mnemonic generateMnemonic({int length = 12, Language language = Language.english}) {
    final List<String> words = bip39.generateWordsRandomly(length, language);
    assert(
    (words.length % 3) == 0 && words.length >= 12 && words.length <= 32,
    'The words length must be 12, 15, 18, 21 or 24',);
    return Mnemonic.from(words);
  }

  @override
  EthPrivateKey createPrivateKey(IBIP39 nnemonic) {
    final buffer = nnemonic.getStringBuffer();

    // Codificar a UTF8
    final List<int> utf8Key = utf8.encode(buffer.toString().trim());
    final List<int> utf8Passphrase = utf8.encode("mnemonic");

    // Encriptar en HMAC-sha512
    final Hmac hmacsha512 = Hmac(sha512, utf8Key);
    final Digest digest = hmacsha512.convert(utf8Passphrase);

    // Encapsular clave privada
    return EthPrivateKey.fromHex(digest.toString());
  }

  @override
  EthSeedPrivateKey createDerivatePrivateKey(IBIP39 nnemonic, String passphrase) {
    final buffer = nnemonic.getStringBuffer();

    final slat = "mnemonic${passphrase}";

    // Codificar a UTF8
    final List<int> utf8Key = utf8.encode(buffer.toString().trim());
    final List<int> utf8Passphrase = utf8.encode(slat);

    // Encriptar en HMAC-sha512
    final Hmac hmacsha512 = Hmac(sha256, utf8Key);
    final Digest digest = hmacsha512.convert(utf8Passphrase);


    // Encapsular clave privada
    return EthSeedPrivateKey(digest);
  }

  @override
  EthPrivateKey getDefaultEthPrivateKey() {
    // TODO: implement getDefaultEthPrivateKey
    throw UnimplementedError();
  }

  @override
  IBip39Wallet createBip39Wallet(String password, File destinationDirectory) {
    // TODO: implement createBip39Wallet
    throw UnimplementedError();
  }
}
