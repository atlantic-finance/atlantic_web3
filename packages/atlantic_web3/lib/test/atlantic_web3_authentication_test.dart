
import 'package:atlantic_web3/atlantic_web3.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  test('IWeb3Authentication', () async {

    await Web3Client.initialize(
      name: 'Mi cliente',
      provider:  HttpProvider('http://localhost:7545'),
    );

    final IWeb3Authentication result = Web3Client.instance.auth;

    result.signOut();

    print('Test passed !!!');
  });
}