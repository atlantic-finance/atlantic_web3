import 'dart:typed_data';

import 'package:atlantic_web3_core/atlantic_web3_core.dart';

class Web3Contract implements IWeb3Contract {
  static const EthBlockNum _defaultBlock = EthBlockNum.current();

  // Principal
  late final BaseProvider _provider;

  /// The lower-level ABI of this contract used to encode data to send in
  /// transactions when calling this contract.
  late final ContractAbi _abi;

  /// The Ethereum address at which this contract is reachable.
  late final EthAddress _address;

  late final FilterEngine _filters;

  Web3Contract(BaseProvider provider, ContractAbi abi, EthAddress address) {
    // Principal
    this._provider = provider;
    this._abi = abi;
    this._address = address;
    this._filters = FilterEngine(_provider);
  }

  String _getBlockParam(EthBlockNum? block) {
    return (block ?? _defaultBlock).toBlockParam();
  }

  BaseProvider get provider => _provider;

  ContractAbi get abi => _abi;

  EthAddress get address => _address;

  /// Finds the event defined by the contract that has the matching [name].
  ///
  /// If no, or more than one event matches that name, this method will throw.
  ContractEvent event(String name) =>
      _abi.events.singleWhere((e) => e.name == name);

  /// Finds the external or public function defined by the contract that has the
  /// provided [name].
  ///
  /// If no, or more than one function matches that description, this method
  /// will throw.
  ContractFunction function(String name) =>
      _abi.functions.singleWhere((f) => f.name == name);

  /// Finds all external or public functions defined by the contract that have
  /// the given name. As solidity supports function overloading, this will
  /// return a list as only a combination of name and types will uniquely find
  /// a function.
  Iterable<ContractFunction> findFunctionsByName(String name) =>
      _abi.functions.where((f) => f.name == name);

  /// Calls a [function] defined in the smart [contract] and returns it's
  /// result.
  ///
  /// The connected node must be able to calculate the result locally, which
  /// means that the call can't write any data to the blockchain. Doing that
  /// would require a transaction which can be sent via [sendTransaction].
  /// As no data will be written, you can use the [sender] to specify any
  /// Ethereum address that would call that function. To use the address of a
  /// credential, call [Credentials.address].
  ///
  /// This function allows specifying a custom block mined in the past to get
  /// historical data. By default, [BlockNum.current] will be used.
  @override
  Future<List<dynamic>> call(
    String name,
    List<dynamic> params, {
    EthBlockNum? atBlock,
  }) async {
    final ContractFunction fn = function(name);

    final encodedResult = await callRaw(
      to: _address,
      data: fn.encodeCall(params),
      atBlock: atBlock,
    );

    return fn.decodeReturnValues(encodedResult);
  }

  /// Sends a raw method call to a smart contract.
  ///
  /// The connected node must be able to calculate the result locally, which
  /// means that the call can't write any data to the blockchain. Doing that
  /// would require a transaction which can be sent via [sendTransaction].
  /// As no data will be written, you can use the [from] to specify any
  /// Ethereum address that would call that function. To use the address of a
  /// credential, call [Credentials.address].
  ///
  /// This function allows specifying a custom block mined in the past to get
  /// historical data. By default, [BlockNum.current] will be used.
  ///
  /// See also:
  /// - [call], which automatically encodes function parameters and parses a
  /// response.
  @override
  Future<String> callRaw({
    EthAddress? from,
    required EthAddress to,
    required Uint8List data,
    EthBlockNum? atBlock,
  }) {
    return _provider.request<String>(
      'eth_call',
      [
        {
          if (from != null) 'from': from.hex,
          'to': to.hex,
          'data': bytesToHex(data, include0x: true, padToEvenLength: true),
        },
        _getBlockParam(atBlock),
      ],
    );
  }

  /// Gets the code of a contract at the specified [address]
  ///
  /// This function allows specifying a custom block mined in the past to get
  /// historical data. By default, [BlockNum.current] will be used.
  @override
  Future<Uint8List> getCode(EthAddress address, {EthBlockNum? atBlock}) async {
    final blockParam = _getBlockParam(atBlock);
    final hex = await _provider.request<String>(
      'eth_getCode',
      [address.hex, blockParam],
    );
    return hexToBytes(hex);
  }
}
