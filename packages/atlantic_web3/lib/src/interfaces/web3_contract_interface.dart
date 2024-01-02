import 'dart:typed_data';

import 'package:atlantic_web3/atlantic_web3.dart';

abstract class IWeb3Contract {
  BaseProvider get provider;

  ContractAbi get abi;

  EthAccount get address;

  ContractEvent event(String name);

  ContractFunction function(String name);

  Iterable<ContractFunction> findFunctionsByName(String name);

  Future<List<dynamic>> call(
    String name,
    List<dynamic> params, {
    EthBlockNum? atBlock,
  });

  Future<String> callRaw({
    EthAccount? from,
    required EthAccount to,
    required Uint8List data,
    EthBlockNum? atBlock,
  });

  Future<Uint8List> getCode(EthAccount address, {EthBlockNum? atBlock});
}
