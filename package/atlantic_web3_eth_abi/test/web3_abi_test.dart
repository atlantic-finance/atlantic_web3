import 'package:atlantic_web3_eth_abi/src/web3_abi.dart';
import 'package:atlantic_web3_providers_http/atlantic_web3_providers_http.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Web3ABI web3;

  setUp(() async {
    web3 = Web3ABI(HttpProvider('http://localhost:7545'));
  });

  //echo
  test('getCompilers', () async {
    final result = await web3.getCompilers();

    print(result);

    print('Test passed !!!');
  });

  //echo
  test('compilerSolidity', () async {
    final String source = '''
      contract test {
        function multiply(uint a) returns(uint d) {
          return a * 7;
        }
      }''';

    final result = await web3.compilerSolidity(source);

    print(result);

    print('Test passed !!!');
  });

  //echo
  test('compilerLLL', () async {
    final String source = '';

    final result = await web3.compilerLLL(source);

    print(result);

    print('Test passed !!!');
  });

  //echo
  test('compilerSerpent', () async {
    final String source = '/* some serpent */';

    final result = await web3.compilerSerpent(source);

    print(result);

    print('Test passed !!!');
  });
}
