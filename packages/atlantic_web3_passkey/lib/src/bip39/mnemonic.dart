import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import '../bip32/seed.dart';
import '../utils/uint8list_extensions.dart';
import 'wordlist.dart';

abstract class IBIP39 {
  List<String> getWords();

  IBIP32 toSeed({String passphrase = "m/44'/60'/0'/0/0"});
}

class Mnemonic implements IBIP39 {
  late List<String> _words;

  // ignore: unused_element
  Mnemonic._();

  // Create from list of words
  Mnemonic.from(List<String> words) {
    assert(
      (words.length % 3) == 0 && words.length >= 12 && words.length <= 32,
      'The words length must be 12, 15, 18, 21 or 24',
    );
    _words = words;
  }

  // Create from string
  Mnemonic.fromString(String str) {
    final List<String> words = str.split(' ');
    assert(
      (words.length % 3) == 0 && words.length >= 12 && words.length <= 32,
      'The words length must be 12, 15, 18, 21 or 24',
    );
    _words = words;
  }

  // Generate a new mnemonic randomly
  Mnemonic.generate({int length = 12}) {
    final List<String> words = _generateWordsRandomly(length);
    assert(
      (words.length % 3) == 0 && words.length >= 12 && words.length <= 32,
      'The words length must be 12, 15, 18, 21 or 24',
    );
    _words = words;
  }

  // Get list of words
  @override
  List<String> getWords() {
    return _words;
  }

  /// Generate the seed from the mnemonic and passphrase
  @override
  IBIP32 toSeed({String passphrase = "m/44'/60'/0'/0/0"}) {
    // Convert list of words to string
    final buffer = StringBuffer();

    for (var i = 0; i < _words.length; i++) {
      buffer.write(_words.elementAt(i));
      if (i < _words.length - 1) {
        buffer.write(' ');
      }
    }

    //print(buffer.toString().trim());

    final key = utf8.encode(buffer.toString().trim()); //words
    final derive = utf8.encode(passphrase); //passphrase

    final hmacSha256 = Hmac(sha256, key); // HMAC-SHA256

    final digest = hmacSha256.convert(derive);

    return Seed(digest);
  }

  /// Formula
  /// ENT = 128
  /// CS = ENT / 32
  /// MS = (ENT + CS) / 11
  List<String> _generateWordsRandomly(int length) {
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

    final wordList = WordList.english;
    final mnemonic = wordIndexes.map((index) => wordList[index]).toList();

    return mnemonic;
  }

  String _calculateBinaryChecksum(Uint8List data) {
    final checksum = data.length ~/ 4; // 32 / 8 = 4 bits
    final List<int> hash = sha256.convert(data).bytes;
    return hash.toBinary().substring(0, checksum);
  }
}
