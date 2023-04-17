import 'package:atlantic_web3_net/atlantic_web3_net.dart';
import 'package:atlantic_web3_providers_http/atlantic_web3_providers_http.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Web3Net web3;

  setUp(() async {
    web3 = Web3Net(HttpProvider('http://localhost:7545'));
  });

  test('getNetworkId', () async {
    final result = await web3.getNetworkId();

    print(result);
    expect(result, equals(5777));

    print('Test passed !!!');
  });

  test('isListeningForNetwork', () async {
    final result = await web3.isListeningForNetwork();

    print(result);
    expect(result, equals(true));

    print('Test passed !!!');
  });

  test('getPeerCount', () async {
    final result = await web3.getPeerCount();

    print(result);
    expect(result, equals(0));

    print('Test passed !!!');
  });
}
