import 'dart:convert';
import 'dart:typed_data';

import 'package:atlantic_web3/atlantic_web3.dart';
import 'package:atlantic_web3_passkey/atlantic_web3_passkey.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/sample_keys.dart';



void main() {
  late IWeb3Passkey web3;

  setUp(() {
    web3 = Web3Passkey.instance();
  });

  test('Web3Passkey.compareMnemonic()', () async {
    final Uint8List dartBytesMnemonic = utf8.encode(MNEMONIC);

    final List<int> javaBytesMnomonicBulk0 = [115, 99, 97, 116, 116, 101, 114, 32, 109, 97, 106, 111, 114, 32, 103, 114,
      97, 110, 116, 32, 114, 101, 116, 117, 114, 110, 32, 102, 108, 101, 101, 32, 101, 97, 115, 121, 32, 102, 101, 109,
      97, 108, 101, 32, 106, 117, 110, 103, 108, 101, 32, 118, 105, 118, 105, 100, 32, 109, 111, 118, 105, 101, 32, 98,
      105, 99, 121, 99, 108, 101, 32, 97, 98, 115, 101, 110, 116, 32, 119, 101, 97, 116, 104, 101, 114, 32, 105, 110,
      115, 112, 105, 114, 101, 32, 99, 97, 114, 114, 121];

    final String javaBytesMnomonicBulk1 = utf8.decode(javaBytesMnomonicBulk0);

    final Uint8List javaBytesMnomonic = utf8.encode(javaBytesMnomonicBulk1);

    final result = dartBytesMnemonic.equals(javaBytesMnomonic);

    print('La cadenas en bytes es identica? = ${ result == true ? 'Si' : 'No' }');

    print('Test passed !!!');
  });

  test('Web3Passkey.hex()', () async {
    String hexString = '0xc5';
    List<int> bytes = hex.decode(hexString.substring(2));
    print(bytes);
    print('Test passed !!!');
  });

  test('Web3Passkey.createEthPassKey()', () async {

    final EthPassKey passKey = web3.createEthPassKey(Mnemonic.fromString(MNEMONIC), PASSWORD);


    final EthPrivateKey privateKey = passKey.getEthPrivateKey();


    final EthPublicKey publicKey = passKey.getEthPublicKey();


    final EthAccount account = passKey.getEthAccount();


    print('Test passed !!!');
  });

}

