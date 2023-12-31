import 'package:atlantic_web3/atlantic_web3.dart';

/// Utility class to easily convert amounts of Ether into different units of
/// quantities.
class EthAmount {
  const EthAmount.inWei(this._value);

  EthAmount.zero() : this.inWei(BigInt.zero);

  /// Constructs an amount of Ether by a unit and its amount. [amount] can
  /// either be a base10 string, an int or a BigInt.
  @Deprecated(
    'Please use fromInt, fromBigInt or fromBase10String.',
  )
  factory EthAmount.fromUnitAndValue(EthUnit unit, dynamic amount) {
    BigInt parsedAmount;

    if (amount is BigInt) {
      parsedAmount = amount;
    } else if (amount is int) {
      parsedAmount = BigInt.from(amount);
    } else if (amount is String) {
      parsedAmount = BigInt.parse(amount);
    } else {
      throw ArgumentError('Invalid type, must be BigInt, string or int');
    }

    return EthAmount.inWei(parsedAmount * _factors[unit]!);
  }

  /// Constructs an amount of Ether by a unit and its amount.
  factory EthAmount.fromInt(EthUnit unit, int amount) {
    final wei = _factors[unit]! * BigInt.from(amount);

    return EthAmount.inWei(wei);
  }

  /// Constructs an amount of Ether by a unit and its amount.
  factory EthAmount.fromBigInt(EthUnit unit, BigInt amount) {
    final wei = _factors[unit]! * amount;

    return EthAmount.inWei(wei);
  }

  /// Constructs an amount of Ether by a unit and its amount.
  factory EthAmount.fromBase10String(EthUnit unit, String amount) {
    final wei = _factors[unit]! * BigInt.parse(amount);

    return EthAmount.inWei(wei);
  }

  /// Gets the value of this amount in the specified unit as a whole number.
  /// **WARNING**: For all units except for [EthUnit.wei], this method will
  /// discard the remainder occurring in the division, making it unsuitable for
  /// calculations or storage. You should store and process amounts of ether by
  /// using a BigInt storing the amount in wei.
  BigInt getValueInUnitBI(EthUnit unit) => _value ~/ _factors[unit]!;

  static final Map<EthUnit, BigInt> _factors = {
    EthUnit.wei: BigInt.one,
    EthUnit.kwei: BigInt.from(10).pow(3),
    EthUnit.mwei: BigInt.from(10).pow(6),
    EthUnit.gwei: BigInt.from(10).pow(9),
    EthUnit.szabo: BigInt.from(10).pow(12),
    EthUnit.finney: BigInt.from(10).pow(15),
    EthUnit.ether: BigInt.from(10).pow(18),
  };

  final BigInt _value;

  BigInt get getInWei => _value;

  BigInt get getInEther => getValueInUnitBI(EthUnit.ether);

  /// Gets the value of this amount in the specified unit. **WARNING**: Due to
  /// rounding errors, the return value of this function is not reliable,
  /// especially for larger amounts or smaller units. While it can be used to
  /// display the amount of ether in a human-readable format, it should not be
  /// used for anything else.
  double getValueInUnit(EthUnit unit) {
    final factor = _factors[unit]!;
    final value = _value ~/ factor;
    final remainder = _value.remainder(factor);

    return value.toInt() + (remainder.toInt() / factor.toInt());
  }

  @override
  String toString() {
    return 'EtherAmount: $getInWei wei';
  }

  @override
  int get hashCode => getInWei.hashCode;

  @override
  bool operator ==(dynamic other) =>
      other is EthAmount && other.getInWei == getInWei;
}
