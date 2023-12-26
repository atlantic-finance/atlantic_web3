import 'dart:typed_data';

import 'package:atlantic_web3_core/atlantic_web3_core.dart';
import 'package:atlantic_web3_passkey/atlantic_web3_passkey.dart';
import 'package:atlantic_web3_passkey/src/utils/enums.dart';
import 'package:bip32/bip32.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hex/hex.dart';

void main() {
  late Web3Passkey web3;

  setUp(() => {
    web3 = Web3Passkey()
  });

  test('Web3Passkey.HMAC-SHA512()', () async {
    var example =
        '942965054c6d9cc467c63feb55758bb4a5e44472bc8460209eb9b5d001bd02d6';
    print("HMAC digest as hex string: $example");
    print("HMAC digest string length: ${example.toString().length}");

    EthPrivateKey credentials2 = EthPrivateKey.fromHex(example);

    // In either way, the library can derive the public key and the address
    // from a private key:
    EthAddress address2 = credentials2.getEthAddress();

    print('Ethereum address: ${address2.hex}');
    print("\n");

    final bytes = HEX.decode(example);

    BIP32 node = BIP32.fromSeed(Uint8List.fromList(bytes));

    BIP32 derivateNode = node.derivePath("m/44'/60'/0'/0/0");

    String privateKey = HEX.encode(derivateNode.privateKey!).toString();
    print(privateKey);
    print(privateKey.length);
  });

  test('Web3Passkey.mnemonic() 01', () async {
    print("###############################################");
    print(" Ejemplo 01: Generar mnemonic de manera aleatoria");
    print("###############################################");
    print('\n');

    // Crear palabras
    final Mnemonic mnemonic = web3.generateMnemonic();
    print('Mnemonic: ${mnemonic.getWords()}');
    print('\n');

    // Crear private key
    final EthPrivateKey privatekey = web3.createPrivateKey(mnemonic);
    print("HMAC digest as bytes: ${privatekey.toBytes()}");
    print("HMAC digest as hex string: ${privatekey.toHex()}");
    print("HMAC digest string length: ${privatekey.toHex().length}");
    print('\n');

    // In either way, the library can derive the public key and the address
    // from a private key:
    final EthAddress address1 = privatekey.getEthAddress();

    print('Ethereum address: ${address1.hex}');
    print('\n');

    print('Test passed !!!');
  });
  test('Web3Passkey.mnemonic() 02', () async {
    print("###############################################");
    print(" Ejemplo 02: Generar mnemonic de manera aleatoria con longitud 24");
    print("###############################################");
    print('\n');

    // Max entropy = 256
    final Mnemonic mnemonic = web3.generateMnemonic(length: 24, language: Language.spanish);
    print('Mnemonic: ${mnemonic.getWords()}');
    print('\n');

    // Crear private key
    final EthPrivateKey privatekey = web3.createPrivateKey(mnemonic);
    print("HMAC digest as bytes: ${privatekey.toBytes()}");
    print("HMAC digest as hex string: ${privatekey.toHex()}");
    print("HMAC digest string length: ${privatekey.toHex().length}");
    print('\n');

    // In either way, the library can derive the public key and the address
    // from a private key:
    final EthAddress address2 = privatekey.getEthAddress();

    print('Ethereum address: ${address2.hex}');
    print('\n');

    print('Test passed !!!');
  });
  test('Web3Passkey.mnemonic() 03', () async {
    print("###############################################");
    print(" Ejemplo 03: Generar mnemonic desde una cadena de texto");
    print("###############################################");
    print('\n');

    // Mnemonic from string
    const str =
        'vivid lab sport destroy erosion can bonus genius fire birth message term';
    final Mnemonic mnemonic = Mnemonic.fromString(str);
    print('Mnemonic: ${mnemonic.getWords()}');
    print('\n');

    // Crear private key
    final EthPrivateKey privatekey = web3.createPrivateKey(mnemonic);
    print("HMAC digest as bytes: ${privatekey.toBytes()}");
    print("HMAC digest as hex string: ${privatekey.toHex()}");
    print("HMAC digest string length: ${privatekey.toHex().length}");
    print('\n');

    // In either way, the library can derive the public key and the address
    // from a private key:
    final EthAddress address3 = privatekey.getEthAddress();

    print('Ethereum address: ${address3.hex}');
    print('\n');

    print('Test passed !!!');
  });
  test('Web3Passkey.mnemonic() 04', () async {
    print("###############################################");
    print(" Ejemplo 04: Generar mnemonic desde una lista de palabras");
    print("###############################################");
    print('\n');

    // Especially mnemonic
    final words = [
      'vivid',
      'lab',
      'sport',
      'destroy',
      'erosion',
      'can',
      'bonus',
      'genius',
      'fire',
      'birth',
      'message',
      'term'
    ];
    final Mnemonic mnemonic = Mnemonic.from(words);
    print('Mnemonic: ${mnemonic.getWords()}');
    print('\n');

    // Crear clave semilla
    final EthSeedPrivateKey seed = web3.createDerivatePrivateKey(mnemonic, "m/44'/60'/0'/0/0");

    // Crear private key
    final EthPrivateKey privatekey = seed.toPrivateKey();
    print("HMAC digest as bytes: ${privatekey.toBytes()}");
    print("HMAC digest as hex string: ${privatekey.toHex()}");
    print("HMAC digest string length: ${privatekey.toHex().length}");
    print('\n');

    // In either way, the library can derive the public key and the address
    // from a private key:
    final EthAddress address4 = privatekey.getEthAddress();

    print('Ethereum address: ${address4.hex}');
    print('\n');

    print('Test passed !!!');
  });
}

