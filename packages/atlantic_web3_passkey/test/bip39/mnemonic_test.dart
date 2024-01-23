import 'package:atlantic_web3/atlantic_web3.dart';
import 'package:atlantic_web3_passkey/atlantic_web3_passkey.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late IWeb3Passkey web3;

  setUp(() => {
    web3 = Web3Passkey.instance()
  });

  test('Web3Passkey.mnemonic() 01', () async {
    print("###############################################");
    print(" Ejemplo 01: Generar mnemonic de manera aleatoria");
    print("###############################################");
    print('\n');

    // Crear palabras
    final Mnemonic mnemonic = web3.generateMnemonic() as Mnemonic;
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
    final EthAccount address1 = privatekey.getEthAccount();

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
    final Mnemonic mnemonic = web3.generateMnemonic(length: 24, language: Language.spanish) as Mnemonic;
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
    final EthAccount address2 = privatekey.getEthAccount();

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
    final EthAccount address3 = privatekey.getEthAccount();

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
    final EthSeedPrivateKey seed = web3.createDerivatePrivateKey(mnemonic, "m/44'/60'/0'/0/0") as EthSeedPrivateKey;

    // Crear private key
    final EthPrivateKey privatekey = seed.toPrivateKey();
    print("HMAC digest as bytes: ${privatekey.toBytes()}");
    print("HMAC digest as hex string: ${privatekey.toHex()}");
    print("HMAC digest string length: ${privatekey.toHex().length}");
    print('\n');

    // In either way, the library can derive the public key and the address
    // from a private key:
    final EthAccount address4 = privatekey.getEthAccount();

    print('Ethereum address: ${address4.hex}');
    print('\n');

    print('Test passed !!!');
  });
}

