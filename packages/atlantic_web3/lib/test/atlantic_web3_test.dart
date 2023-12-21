import 'package:atlantic_web3/atlantic_web3.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  test('IWeb3Client', () async {

    await Web3Client.initialize(
      name: 'Mi cliente',
      provider:  HttpProvider('http://localhost:7545'),
    );

    final IWeb3Client result = Web3Client.instance;

    print(result.version);

    print('Test passed !!!');
  });
}