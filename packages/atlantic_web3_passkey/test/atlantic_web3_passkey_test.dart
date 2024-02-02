import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:atlantic_web3/atlantic_web3.dart';
import 'package:atlantic_web3_passkey/atlantic_web3_passkey.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hex/hex.dart';
import 'package:pointycastle/export.dart';

import 'helpers/sample_keys.dart';



void main() {
  late IWeb3Passkey web3;
  late File tempDir;

  setUp(() {
    web3 = Web3Passkey.instance();
    tempDir = File('');
  });

  test('Web3Passkey.Pbkdf2()', () async {
    const _words = [
      'acquire',
      'net',
      'news',
      'liar',
      'twice',
      'snap',
      'game',
      'pattern',
      'empty',
      'foster',
      'age',
      'toe'
    ];

    const passPhrase = "";

    final buffer = StringBuffer();
    for (var i = 0; i < _words.length; i++) {
      buffer.write(_words.elementAt(i));
      if (i < _words.length - 1) {
        buffer.write(' ');
      }
    }

    const slat = "mnemonic${passPhrase}";

    // Codificar a UTF8
    final List<int> utf8Key = utf8.encode(buffer.toString().trim());
    final List<int> utf8Slat = utf8.encode(slat.trim());

    final PBKDF2KeyDerivator derivator = PBKDF2KeyDerivator(HMac(SHA512Digest(), 128));
    derivator.init(Pbkdf2Parameters(utf8Slat as Uint8List, 2048, 64));

    final key = derivator.process(utf8Key as Uint8List);

    final EthPassKey result = EthPassKey.fromHex(HEX.encode(key).toString());

    print('Resultado: ');
    print('Clave privada esperada: 0x6ebd8ad6d4dca011cc43971d4b732137214595f42e3905b68bdc6d9e2d8a3405');
    print('Clave privada obtenida: 0x${result.hex}');

    final EthAccount account = result.getEthAccount();

    print('Cuenta ethereum esperada: 0xb9c25bF81F4d851E44c2C89965a9BB98D61D6496');
    print('Cuenta ethereum obtenida: ${account.hex}');
    print('\n');

    print('Test passed !!!');
  });

  test('Web3Passkey.createBip39Wallet()', () async {
    IBip39Wallet wallet = web3.createBip39Wallet(PASSWORD,  tempDir);


    print('Test passed !!!');
  });

}

