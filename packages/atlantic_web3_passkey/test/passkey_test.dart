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

  test('Web3Passkey.passkey()', () async {
    final keypair = ECKeyPair.fromKeyPairString(PRIVATE_KEY_STRING, PUBLIC_KEY_STRING);

    final passKey = EthPassKey.fromKeyPair(keypair);

    final EthAccount account = passKey.getEthAccount();
    var e = account.hex;
    var f = ADDRESS;
    assert(account.hex == ADDRESS, 'No es igual la direccion de Ethereum');

    print('Test passed !!!');
  });

  test('Web3Passkey.passkey2()', () async {
    final keypair = ECKeyPair.create(hexToBytes(PRIVATE_KEY_STRING));

    final passKey = EthPassKey.fromKeyPair(keypair);

    final EthAccount account = passKey.getEthAccount();
    var e = account.hex;
    var f = ADDRESS;
    assert(account.hex == ADDRESS, 'No es igual la direccion de Ethereum');

    print('Test passed !!!');
  });

  test('Web3Passkey.passkey3()', () async {
    final keypair = ECKeyPair.create(hexToBytes('0x6ebd8ad6d4dca011cc43971d4b732137214595f42e3905b68bdc6d9e2d8a3405'));

    final passKey = EthPassKey.fromKeyPair(keypair);

    final EthAccount account = passKey.getEthAccount();
    var e = account.hex;
    var f = '0xb9c25bf81f4d851e44c2c89965a9bb98d61d6496';
    assert(e == f, 'No es igual la direccion de Ethereum');

    print('Test passed !!!');
  });

  test('Web3Passkey.comparePasskey()', () async {
    //dart
    final BigInt dartPrivateKey =  BigInt.parse('57458847547880240030856167414489482256357658294094444623999178450420787849501');
    final BigInt dartPublicKey = BigInt.parse('6423861798942815137879968279093551601014790657182194664604296570150792584190454811403313904850169111130564710815286309591107414852486073800877068045094617');

    final keypair1 = ECKeyPair.fromKeyPairInt(dartPrivateKey, dartPublicKey);

    //java
    final BigInt javaPrivateKey = BigInt.parse('57458847547880240030856167414489482256357658294094444623999178450420787849501');
    final BigInt javaPublicKey = BigInt.parse('6423861798942815137879968279093551601014790657182194664604296570150792584190454811403313904850169111130564710815286309591107414852486073800877068045094617');

    final keypair2 = ECKeyPair.fromKeyPairInt(javaPrivateKey, javaPublicKey);

    final result = keypair1.equals(keypair2);

    assert(result, 'No es igual los pares de claves');

    final EthPassKey passkey1 = EthPassKey.fromKeyPair(keypair1);

    final EthPassKey passkey2 = EthPassKey.fromKeyPair(keypair2);

    final result2 = passkey1.equals(passkey2);

    assert(result2, 'No es igual la llave de acceso');

    print('Test passed !!!');
  });

  test('Web3Passkey.comparePasskey2()', () async {

    final BigInt privateKey =  BigInt.parse('57458847547880240030856167414489482256357658294094444623999178450420787849501');
    final BigInt publicKey = BigInt.parse('6423861798942815137879968279093551601014790657182194664604296570150792584190454811403313904850169111130564710815286309591107414852486073800877068045094617');

    final passkey1 = EthPassKey.fromKeyPair(ECKeyPair.fromKeyPairInt(privateKey, publicKey));

    final passkey2 = web3.createEthPassKey(Mnemonic.fromString(MNEMONIC), PASSWORD);

    final result2 = passkey1.equals(passkey2);

    assert(result2, 'No es igual la llave de acceso');

    print('Test passed !!!');
  });

  test('Web3Passkey.comparePasskey3()', () async {

    final BigInt privateKey =  BigInt.parse('57458847547880240030856167414489482256357658294094444623999178450420787849501');
    final BigInt publicKey = BigInt.parse('6423861798942815137879968279093551601014790657182194664604296570150792584190454811403313904850169111130564710815286309591107414852486073800877068045094617');

    final passkey1 = EthPassKey.fromKeyPair(ECKeyPair.fromKeyPairInt(privateKey, publicKey));

    final passkey2 = EthPassKey.fromKeyPair(ECKeyPair.fromKeyPairString(PRIVATE_KEY_STRING, PUBLIC_KEY_STRING));


    final result2 = passkey1.equals(passkey2);

    assert(result2, 'No es igual la llave de acceso');

    print('Test passed !!!');
  });

  test('Web3Passkey.saveEthPasskey()', () async {

    final EthPassKey passkey1 = web3.createEthPassKey(Mnemonic.fromString(MNEMONIC), PASSWORD);

    //ID
    const documentId = '3c5b0a43-e0c0-40ea-a698-fe88762382ff';

    final EthPassKey passkey2 = await web3.saveEthPasskey(documentId, 'Mi Wallet', passkey1, PASSWORD);

    final result = passkey1.equals(passkey2);

    assert(result, 'No es igual la llave de acceso');

    print('Test passed !!!');
  });
}

