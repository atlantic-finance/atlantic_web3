
import 'dart:convert';
import 'dart:core';
import 'dart:math';
import 'dart:typed_data';

import 'package:atlantic_web3_core/atlantic_web3_core.dart';
import 'package:atlantic_web3_passkey/atlantic_web3_passkey.dart';
import 'package:atlantic_web3_passkey/src/bip39/word_list_es.dart';
import 'package:atlantic_web3_passkey/src/utils/enums.dart';
import 'package:crypto/crypto.dart';

class Web3Passkey implements IWeb3Passkey {
  Web3Passkey();

  @override
  Mnemonic generateMnemonic({int length = 12, Language language = Language.english}) {
    final List<String> words = _generateWordsRandomly(length, language);
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
    final List<int> utf8Passphrase = utf8.encode("m/44'/60'/0'/0/0");

    // Encriptar en HMAC-SHA256
    final Hmac hmacSha256 = Hmac(sha256, utf8Key);
    final Digest digest = hmacSha256.convert(utf8Passphrase);

    // Encapsular clave privada
    return EthPrivateKey.fromHex(digest.toString());
  }

  @override
  EthSeedPrivateKey createDerivatePrivateKey(IBIP39 nnemonic, String passphrase) {
    final buffer = nnemonic.getStringBuffer();

    // Codificar a UTF8
    final List<int> utf8Key = utf8.encode(buffer.toString().trim());
    final List<int> utf8Passphrase = utf8.encode(passphrase);

    // Encriptar en HMAC-SHA256
    final Hmac hmacSha256 = Hmac(sha256, utf8Key);
    final Digest digest = hmacSha256.convert(utf8Passphrase);

    // Encapsular clave privada
    return EthSeedPrivateKey(digest);
  }

  /// Formula
  /// ENT = 128
  /// CS = ENT / 32
  /// MS = (ENT + CS) / 11
  List<String> _generateWordsRandomly(int length, Language language) {
    if (length % 3 != 0 && length >= 12 && length <= 32) {
      throw ArgumentError.value('The length must be 12, 15, 18, 21 or 24');
    }

    final int entropySize = length ~/ 3 * 32 ~/ 8; // In bit then in byte

    final random = Random.secure();
    var entropy = Uint8List(entropySize);

    for (var i = 0; i < entropySize; i++) {
      entropy[i] = random.nextInt(255);
    }

    List<String> binary = (entropy.toBinary() +
        _calculateBinaryChecksum(entropy) // add checksum at the end
    )
        .split(''); // Make it a list

    final wordIndexes = Uint8List(length);
    for (var i = 0; i < length; i++) {
      wordIndexes[i] =
          int.parse(binary.sublist(0 + i * 11, 11 + i * 11).join(''), radix: 2);
    }

    final wordList = switch (language) {
      Language.english => WordListEn.word,
      Language.spanish => WordListEs.word
    };

    final mnemonic = wordIndexes.map((index) => wordList[index]).toList();

    return mnemonic;
  }

  String _calculateBinaryChecksum(Uint8List data) {
    final checksum = data.length ~/ 4; // 32 / 8 = 4 bits
    final List<int> hash = sha256.convert(data).bytes;
    return hash.toBinary().substring(0, checksum);
  }
}
