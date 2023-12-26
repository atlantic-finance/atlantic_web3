
import 'package:atlantic_web3/atlantic_web3.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  test('Web3Blockchain', () async {

    await Web3Client.initialize(
      name: 'Mi cliente',
      provider:  HttpProvider('http://localhost:7545'),
    );

    final IWeb3Passkey result = Web3Client.instance.passkey;

    result.generateMnemonic();

    print('Test passed !!!');
  });
}