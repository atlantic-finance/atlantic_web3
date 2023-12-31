import 'dart:typed_data';

import 'package:atlantic_web3/atlantic_web3.dart';

/// A function defined in the ABI of an compiled contract.
class ContractFunction {
  /// The name of the function. Can be empty if it's an constructor or the
  /// default function.
  final String name;

  /// The type of the contract function, determines whether this [isConstant] or
  /// [isConstructor].
  final Boolean constant;

  /// A list of types that represent the parameters required to call this
  /// function.
  final List<FunctionParameter> inputs;

  /// The return types of this function.
  final List<FunctionParameter> outputs;

  /// The mutability of this function, determines whether this function is going
  /// to read or write to the blockchain when called.
  final StateMutability mutability;

  /// Constructor.
  const ContractFunction(this.name, this.inputs,
      {this.outputs = const [],
      this.mutability = StateMutability.nonPayable,
      this.constant = false});

  /// Returns true if this is the default function of a contract, which can be
  /// called when no other functions fit to an request.
  bool get isDefault => constant == ContractFunctionType.fallback;

  /// Returns true if this function is an constructor of the contract it belongs
  /// to. Mind that this library does currently not support deploying new
  /// contracts on the blockchain, it only supports calling functions of
  /// existing contracts.
  bool get isConstructor => constant == ContractFunctionType.constructor;

  /// Returns true if this function is constant, i.e. it cannot modify the state
  /// of the blockchain when called. This allows the function to be called
  /// without sending Ether or gas as the connected client can compute it
  /// locally, no expensive mining will be required.
  bool get isConstant =>
      mutability == StateMutability.view || mutability == StateMutability.pure;

  /// Returns true if this function can be used to send Ether to a smart
  /// contract that the contract will actually keep. Normally, all Ether sent
  /// with a transaction will be used to pay for gas fees and the rest will be
  /// sent back. Here however, the Ether (minus the fees) will be kept by the
  /// contract.
  bool get isPayable => mutability == StateMutability.payable;

  /// Encodes a call to this function with the specified parameters for a
  /// transaction or a call that can be sent to the network.
  ///
  /// The [params] must be a list of dart types that will be converted. The
  /// following list shows what dart types are supported by what solidity/abi
  /// parameter types.
  ///
  /// * arrays (static and dynamic size), unless otherwise specified, will
  /// 	accept a dart List of the type of the array. The type "bytes" will
  /// 	accept a list of ints that should be in [0; 256].
  /// * strings will accept an dart string
  /// * bool will accept a dart bool
  /// * uint<x> and int<x> will accept a dart int
  ///
  /// Other types are not supported at the moment.
  Uint8List encodeCall(List<dynamic> params) {
    if (params.length != inputs.length) {
      throw ArgumentError.value(
        params.length,
        'params',
        'Must match function parameters',
      );
    }

    final sink = LengthTrackingByteSink()
      //First four bytes to identify the function with its parameters
      ..add(selector);

    TupleType(inputs.map((param) => param.type).toList()).encode(params, sink);

    return sink.asBytes();
  }

  /// Encodes the name of the function and its required parameters.
  ///
  /// The encoding is specified here: https://solidity.readthedocs.io/en/develop/abi-spec.html#function-selector
  /// although this method will not apply the hash and just return the name
  /// followed by the types of the parameters, like this: bar(bytes,string[])
  String encodeName() {
    final parameterTypes = _encodeParameters(inputs);
    return '$name($parameterTypes)';
  }

  /// The selector of this function, as described [by solidity].
  ///
  /// [by solidity]: https://solidity.readthedocs.io/en/develop/abi-spec.html#function-selector
  Uint8List get selector {
    return keccakUtf8(encodeName()).sublist(0, 4);
  }

  /// Uses the known types of the function output to decode the value returned
  /// by a contract after making an call to it.
  ///
  /// The type of what this function returns is thus dependent from what it
  /// [outputs] are. For the conversions between dart types and solidity types,
  /// see the documentation for [encodeCall].
  List<dynamic> decodeReturnValues(String data) {
    final tuple = TupleType(outputs.map((p) => p.type).toList());
    final buffer = hexToBytes(data).buffer;

    final parsedData = tuple.decode(buffer, 0);
    return parsedData.data;
  }

  String _encodeParameters(Iterable<FunctionParameter> params) {
    return params.map((p) => p.type.name).join(',');
  }
}
