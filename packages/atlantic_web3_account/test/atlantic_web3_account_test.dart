import 'package:atlantic_web3/src/providers/base_provider.dart';
import 'package:atlantic_web3_account/atlantic_web3_account.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web3_providers_http/web3_providers_http.dart';

void main() {
  late Web3Authentication web3;

  setUp(() async {
    web3 = Web3Authentication(HttpProvider('http://localhost:7545') as BaseProvider);
  });

  test('signIn', () async {
    final result = await web3.signIn();

    print(result);

    print('Test passed !!!');
  });
}
