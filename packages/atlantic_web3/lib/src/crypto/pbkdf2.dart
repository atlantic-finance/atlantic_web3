
import 'dart:convert';
import 'dart:typed_data';

import 'package:atlantic_web3/atlantic_web3.dart';
import 'package:pointycastle/export.dart';

final class Pbkdf2Helpers {
  static const Integer SEED_ITERATIONS = 2048;
  static const Integer SEED_KEY_SIZE = 512;

  static List<int> createSeedFromMnemonic(IMnemonic nnemonic, String passphrase) {
    final buffer = nnemonic.getStringBuffer();

    // Create slat
    final slat = "mnemonic${passphrase}";

    // Codificar a UTF8
    final List<int> utf8Key = utf8.encode(buffer.toString().trim());
    final List<int> utf8Slat = utf8.encode(slat);

    // Encriptar en HMAC-sha512
    final PBKDF2KeyDerivator derivator = PBKDF2KeyDerivator(HMac(SHA512Digest(), 128));
    derivator.init(Pbkdf2Parameters(utf8Slat as Uint8List, SEED_ITERATIONS, SEED_KEY_SIZE));

    final Uint8List key = derivator.process(utf8Key as Uint8List);

    return key as List<int>;
  }
}
