// ignore_for_file: public_member_api_docs

import 'package:web3dart/atlantic_web3.dart';

const String privateKey =
    'a2fd51b96dc55aeb14b30d55a6b3121c7b9c599500c1beb92a389c3377adc86e';
const String rpcUrl = 'http://localhost:7545';

Future<void> main() async {
  // start a client we can use to send transactions
  final client = Web3Client(HttpProvider(rpcUrl));

  final credentials = EthPrivateKey.fromHex(privateKey);
  final address = credentials.address;

  print(address.hexEip55);
  print(await client.eth.getBalance(address));

  await client.eth.sendTransaction(
    credentials,
    EthTransaction2(
      to: EthAddress.fromHex('0xC914Bb2ba888e3367bcecEb5C2d99DF7C7423706'),
      gasPrice: EthAmount.inWei(BigInt.one),
      gas: 100000,
      value: EthAmount.fromInt(EthUnit.ether, 1),
    ),
  );

  await client.eth.cleanEvent();
}
