import 'package:atlantic_web3_core/atlantic_web3_core.dart';
import 'package:atlantic_web3_eth_contract/atlantic_web3_eth_contract.dart';
import 'package:atlantic_web3_providers_http/atlantic_web3_providers_http.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Web3Contract web3;

  setUp(() async {
    //establecer ABI
    final contractAbi = await parseAbiFromFile('test_resources/Famton.json');

    //establecer direccion
    final contractAddress =
        EthAddress.fromHex('0x079420476b1024d3cBe013697Ba47497257e5175');

    web3 = Web3Contract(
        HttpProvider('http://localhost:7545'), contractAbi, contractAddress);
  });

  //echo
  test('call', () async {
    final result = await web3.call('totalSupply', []);

    print(result);

    print('Test passed !!!');
  });

  //echo
  test('callRaw', () async {
    final ContractFunction fn = web3.function('totalSupply');

    final encodedResult = await web3.callRaw(
      to: web3.address,
      data: fn.encodeCall([]),
    );

    final result = fn.decodeReturnValues(encodedResult);

    print(result);

    print('Test passed !!!');
  });

  //echo
  test('getCode', () async {
    final address = web3.address;

    final result = await web3.getCode(address);

    print(result);

    print('Test passed !!!');
  });
}
