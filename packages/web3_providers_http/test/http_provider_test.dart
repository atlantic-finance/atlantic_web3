import 'package:atlantic_web3_core/atlantic_web3_core.dart';
import 'package:web3_providers_http/src/http_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String BASE_URL = 'http://localhost:7545';
  const EthBlockNum defaultBlock = EthBlockNum.current();

  test('Http provider', () async {
    final provider = HttpProvider(BASE_URL);

    final data = await provider.request('eth_getBalance', [
      '0xb33b6d5ffe542e87a760ae61e28ce6358da799fc',
      defaultBlock.toBlockParam()
    ]);

    final amount = EthAmount.fromBigInt(EthUnit.wei, hexToBigInt(data));

    print(amount.getValueInUnit(EthUnit.ether));
  });
}
