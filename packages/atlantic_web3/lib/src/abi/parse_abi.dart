import 'dart:convert';
import 'dart:io';

import 'package:atlantic_web3/atlantic_web3.dart';

Future<ContractAbi> parseAbiFromFile(String path) async {
  final abi = await File(path).readAsString();
  return parseAbi(abi);
}

Future<ContractAbi> parseAbi(String jsonString) async {
  final data = json.decode(jsonString);

  // Vars
  final String name = data['contractName'];
  final events = <ContractEvent>[];
  final functions = <ContractFunction>[];

  // Get elements of the contract
  for (final Map element in data['abi']) {
    final flagType = element['type'] as String;

    // Processing only event
    if (flagType == 'event') {
      final name = (element['name'] as String?) ?? '';
      final anonymous = element['anonymous'] as bool;
      final inputs = _parseEventParams(element['inputs'] as List?);

      final event = ContractEvent(name, anonymous, inputs);

      events.add(event);
      continue;
    }

    if (flagType == 'function') {
      final name = (element['name'] as String?) ?? '';
      final mutability = (_mutabilityNames[element['stateMutability']]) ??
          StateMutability.nonPayable;
      final constant =
          element.containsKey('constant') ? element['constant'] as bool : false;

      final inputs = _parseFunctionParams(element['inputs'] as List?);
      final outputs = _parseFunctionParams(element['outputs'] as List?);

      final function = ContractFunction(
        name,
        inputs,
        outputs: outputs,
        mutability: mutability,
        constant: constant,
      );

      functions.add(function);
      continue;
    }
  }

  return ContractAbi(name, events, functions);
}

const Map<String, ContractFunctionType> _functionTypeNames = {
  'function': ContractFunctionType.function,
  'constructor': ContractFunctionType.constructor,
  'fallback': ContractFunctionType.fallback,
};

const Map<String, StateMutability> _mutabilityNames = {
  'pure': StateMutability.pure,
  'view': StateMutability.view,
  'nonpayable': StateMutability.nonPayable,
  'payable': StateMutability.payable,
};

List<EventParameter> _parseEventParams(List? data) {
  if (data == null || data.isEmpty) return [];

  final elements = <EventParameter>[];

  for (final entry in data) {
    final name = entry['name'] as String;
    final type = _parseType(entry['type'] as String);
    final internalType = _parseType(entry['internalType'] as String);
    final indexed = entry['indexed'] as Boolean;

    final parameter = EventParameter(name, type, internalType, indexed);

    elements.add(parameter);
  }

  return elements;
}

List<FunctionParameter> _parseFunctionParams(List? data) {
  if (data == null || data.isEmpty) return [];

  final elements = <FunctionParameter>[];
  for (final entry in data) {
    final name = (entry['name'] as String?) ?? '';
    final type = _parseType(entry['type'] as String);
    final internalType = _parseType(entry['internalType'] as String);

    final parameter = FunctionParameter(name, type, internalType);

    elements.add(parameter);
  }

  return elements;
}

AbiType _parseType(String type) {
  AbiType result = BoolType();

  switch (type) {
    case 'int8':
      result = IntType(length: 8);
      break;

    case 'int256':
      result = IntType();
      break;

    case 'uint8':
      result = UintType(length: 8);
      break;

    case 'uint256':
      result = UintType();
      break;

    case 'bool':
      result = BoolType();
      break;

    case 'string':
      result = StringType();
      break;

    case 'address':
      result = AddressType();
      break;

    default:
      throw InvalidPrivateKeyError();
  }
  return result;
}

CompositeFunctionParameter _parseTuple(
  String name,
  String typeName,
  List<FunctionParameter> components,
) {
  // The type will have the form tuple[3][]...[1], where the indices after the
  // tuple indicate that the type is part of an array.
  assert(
    RegExp(r'^tuple(?:\[\d*\])*$').hasMatch(typeName),
    '$typeName is an invalid tuple type',
  );

  final arrayLengths = <int?>[];
  var remainingName = typeName;

  while (remainingName != 'tuple') {
    final arrayMatch = array.firstMatch(remainingName)!;
    remainingName = arrayMatch.group(1)!;

    final insideSquareBrackets = arrayMatch.group(2)!;
    if (insideSquareBrackets.isEmpty) {
      arrayLengths.insert(0, null);
    } else {
      arrayLengths.insert(0, int.parse(insideSquareBrackets));
    }
  }

  return CompositeFunctionParameter(name, components, arrayLengths);
}
