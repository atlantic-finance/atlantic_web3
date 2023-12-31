import 'package:atlantic_web3/atlantic_web3.dart';

/// Contract Function Type
enum ContractFunctionType {
  /// Function
  function,

  /// Constructor
  constructor,

  /// Fallback
  fallback,
}

/// The state mutability of a contract function defines how that function
/// interacts with the blockchain.
///
/// Functions whose mutability is either [pure] or [view] promise to not write
/// data to the blockchain. This allows Ethereum nodes to execute them locally
/// instead of sending a transaction for the invocation. That in turn makes them
/// free to use. Mutable functions, like [nonPayable] or [payable] may write to
/// the blockchain, which means that they can only be executed as part of a
/// transaction, which has gas costs.
enum StateMutability {
  /// Function whose output depends solely on it's input. It does not ready any
  /// state from the blockchain.
  pure,

  /// Function that reads from the blockchain, but doesn't write to it.
  view,

  /// Function that may write to the blockchain, but doesn't accept any Ether.
  nonPayable,

  /// Function that may write to the blockchain and additionally accepts Ether.
  payable,
}

/// Defines the abi of a deployed Ethereum contract. The abi contains
/// information about the functions defined in that contract.
class ContractAbi {
  /// Name of the contract
  final String _name;

  /// Events.
  final List<ContractEvent> _events;

  /// All functions (including constructors) that the ABI of the contract
  /// defines.
  final List<ContractFunction> _functions;

  // ignore: unused_element
  ContractAbi(this._name, this._events, this._functions);

  String get name => _name;

  List<ContractEvent> get events => _events;

  List<ContractFunction> get functions => _functions;
}
