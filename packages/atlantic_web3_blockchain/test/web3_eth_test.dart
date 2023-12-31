import 'package:atlantic_web3_blockchain/atlantic_web3_blockchain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web3_providers_http/web3_providers_http.dart';

void main() {
  late Web3Eth web3;

  setUp(() async {
    web3 = Web3Eth(HttpProvider('http://localhost:7545') as BaseProvider);
  });

  //echo
  test('credentialsFromPrivateKey', () async {
    final result = await web3.credentialsFromPrivateKey(
        '0xb33b6d5ffe542e87a760ae61e28ce6358da799fc');

    print(result);

    print('Test passed !!!');
  });

  //echo
  test('estimateGas', () async {
    final transaction = EthTransaction(
      from: EthAddress.fromHex('0xb33b6d5ffe542e87a760ae61e28ce6358da799fc'),
      to: EthAddress.fromHex('0xcEeC807Ec44F5282f8c86eA1ddb845Ca2CCa4294'),
      value: EthAmount.fromInt(EthUnit.ether, 3),
      gas: 25000,
      gasPrice: EthAmount.fromInt(EthUnit.wei, 1),
    );

    final BigInt result = await web3.estimateGas(transaction);
    final BigInt compare = BigInt.from(21000);
    print(result);

    assert(result == compare);

    print('Test passed !!!');
  });

  //echo
  test('getAccounts', () async {
    final result = await web3.getAccounts();

    print(result);

    print('Test passed !!!');
  });

  //echo
  test('getBalance', () async {
    final address =
        EthAddress.fromHex('0xb33b6d5ffe542e87a760ae61e28ce6358da799fc');

    final result = await web3.getBalance(address);
    print(result);

    print('Test passed !!!');
  });

  //echo
  test('getBlock', () async {
    final result = await web3.getBlock();

    print(result);

    print('Test passed !!!');
  });

  //echo
  test('getBlockNumber', () async {
    final result = await web3.getBlockNumber();

    print(result);

    print('Test passed !!!');
  });

  //echo
  test('getBlockTransactionCount', () async {
    final result = await web3.getBlockTransactionCount();

    print(result);

    print('Test passed !!!');
  });

  //echo
  test('getBlockUncleCount', () async {
    final result = await web3.getBlockUncleCount();

    print(result);

    print('Test passed !!!');
  });

  //echo
  test('getChainId', () async {
    final result = await web3.getChainId();

    print(result);

    print('Test passed !!!');
  });

  //echo
  test('getClientVersion', () async {
    final result = await web3.getClientVersion();

    print(result);
    expect(result, contains('EthereumJS TestRPC/v2.13.1/ethereum-js'));

    print('Test passed !!!');
  });

  //echo
  test('getCoinbase', () async {
    final result = await web3.getCoinbase();

    print(result);

    print('Test passed !!!');
  });

  //echo
  test('getGasPrice', () async {
    final result = await web3.getGasPrice();

    print(result);

    print('Test passed !!!');
  });

  //echo
  test('getHashRate', () async {
    final result = await web3.getHashRate();

    print(result);

    print('Test passed !!!');
  });

  //echo
  test('getProtocolVersion', () async {
    final result = await web3.getClientVersion();

    print(result);
    expect(result, contains('EthereumJS TestRPC/v2.13.1/ethereum-js'));

    print('Test passed !!!');
  });

  //echo
  test('getSyncStatus', () async {
    final result = await web3.getSyncStatus();

    print(result);

    print('Test passed !!!');
  });

  //echo
  test('getTransaction', () async {
    final txHash =
        '0x7b57981c766f04cf7f75fe70af85d0a86545c07c14e0ed968ee7bc7735db8bd3';

    final result = await web3.getTransaction(txHash);

    print(result);

    print('Test passed !!!');
  });

  //echo
  test('getTransactionCount', () async {
    final address =
        EthAddress.fromHex('0xb33b6d5ffe542e87a760ae61e28ce6358da799fc');

    final result = await web3.getTransactionCount(address);

    print(result);

    print('Test passed !!!');
  });

  //echo
  test('getTransactionFromBlock', () async {
    final result = await web3.getTransactionFromBlock(EthBlockNum.current(), 0);

    print(result);

    print('Test passed !!!');
  });

  //echo
  test('getTransactionReceipt', () async {
    final txHash =
        '0x7b57981c766f04cf7f75fe70af85d0a86545c07c14e0ed968ee7bc7735db8bd3';

    final result = await web3.getTransactionReceipt(txHash);

    print(result);

    print('Test passed !!!');
  });

  //echo
  test('getUncleFromBlock', () async {
    final result = await web3.getUncleFromBlock(EthBlockNum.current(), 0);

    print(result);

    print('Test passed !!!');
  });

  //echo
  test('getWork', () async {
    final result = await web3.getWork();

    print(result);

    print('Test passed !!!');
  });

  //echo
  test('isMining', () async {
    final result = await web3.isMining();

    print(result);

    print('Test passed !!!');
  });

  //echo
  test('isSyncing', () async {
    final result = await web3.isSyncing();

    print(result);

    print('Test passed !!!');
  });
}
