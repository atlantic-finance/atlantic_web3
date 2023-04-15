import 'package:atlantic_web3_core/atlantic_web3_core.dart';

/// A [FunctionParameter] that is a component of an event. Contains additional
/// information about whether the parameter is [indexed].
class EventParameter<T> {
  /// Constructor.
  const EventParameter(this.name, this.type, this.internalType, this.indexed);

  /// Name.
  final String name;

  /// Type.
  final AbiType<T> type;

  /// Type.
  final AbiType<T> internalType;

  /// Indexed.
  final bool indexed;
}

/// The parameter of a function with its name and the expected type.
class FunctionParameter<T> {
  /// Constructor.
  const FunctionParameter(this.name, this.type, this.internalType);

  /// Name.
  final String name;

  /// Type.
  final AbiType<T> type;

  /// Type.
  final AbiType<T> internalType;
}

/// A function parameter that includes other named parameter instead of just
/// wrapping single types.
///
/// Consider this contract:
/// ```solidity
/// pragma solidity >=0.4.19 <0.7.0;
/// pragma experimental ABIEncoderV2;
///
/// contract Test {
///   struct S { uint a; uint[] b; T[] c; }
///   struct T { uint x; uint y; }
///   function f(S memory s, T memory t, uint a) public;
///   function g() public returns (S memory s, T memory t, uint a);
/// }
/// ```
/// For the parameter `s` in the function `f`, we still want to know the names
/// of the components in the tuple. Simply knowing that it's a tuple is not
/// enough. Similarly, we want to know the names of the parameters of `T` in
/// `S.c`.
class CompositeFunctionParameter extends FunctionParameter<dynamic> {
  /// Constructor.
  CompositeFunctionParameter(String name, this.components, this.arrayLengths)
      : super(name, _constructType(components, arrayLengths),
            _constructType(components, arrayLengths));

  /// Components.
  final List<FunctionParameter> components;

  /// If the composite type is wrapped in arrays, contains the length of these
  /// arrays. For instance, given a struct `S`, the type `S[3][][4]` would be
  /// represented with a [CompositeFunctionParameter] that has the components of
  /// `S` and [arrayLengths] of `[3, null, 4]`.
  final List<int?> arrayLengths;

  static AbiType<dynamic> _constructType(
    List<FunctionParameter> components,
    List<int?> arrayLengths,
  ) {
    AbiType type = TupleType(components.map((c) => c.type).toList());

    for (final len in arrayLengths) {
      if (len != null) {
        type = FixedLengthArray(type: type, length: len);
      } else {
        type = DynamicLengthArray(type: type);
      }
    }

    return type;
  }
}
