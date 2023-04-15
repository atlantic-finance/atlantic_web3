import 'dart:typed_data';

import 'package:atlantic_web3_core/atlantic_web3_core.dart';
import 'package:atlantic_web3_core/src/utils/equality.dart' as eq;

class EthTransaction {
  /// A hash of this transaction, in hexadecimal representation.
  final Uint8List? hash;

  /// The nonce of this transaction. A nonce is incremented per sender and
  /// transaction to make sure the same transaction can't be sent more than
  /// once.
  final int? nonce;

  /// The hash of the block containing this transaction. If this transaction has
  /// not been mined yet and is thus in no block, it will be `null`
  final Uint8List? blockHash;

  /// [EthBlockNum] of the block containing this transaction, or [BlockNum.pending]
  /// when the transaction is not part of any block yet.
  final EthBlockNum? blockNumber;

  /// Integer of the transaction's index position in the block. `null` when it's
  /// pending.
  int? transactionIndex;

  /// The sender of this transaction.
  final EthAddress? from;

  /// Address of the receiver. `null` when its a contract creation transaction
  final EthAddress? to;

  /// The amount of Ether sent with this transaction.
  final EthAmount? value;

  /// How many units of gas have been used in this transaction.
  final int? gas;

  /// The amount of Ether that was used to pay for one unit of gas.
  final EthAmount? gasPrice;

  /// The data sent with this transaction.
  final Uint8List? input;

  /// A cryptographic recovery id which can be used to verify the authenticity
  /// of this transaction together with the signature [r] and [s]
  final int? v;

  /// ECDSA signature r
  final BigInt? r;

  /// ECDSA signature s
  final BigInt? s;

  EthTransaction({
    this.hash,
    this.nonce,
    this.blockHash,
    this.blockNumber,
    this.transactionIndex,
    this.from,
    this.to,
    this.value,
    this.gas,
    this.gasPrice,
    this.input,
    this.v,
    this.r,
    this.s,
  });

  EthTransaction.fromJson(Map<String, dynamic> json)
      : hash = hexToBytes(json['hash'] as String),
        nonce = int.parse(json['nonce'] as String),
        blockHash = hexToBytes(json['blockHash'] as String),
        blockNumber = json['blockNumber'] != null
            ? EthBlockNum.exact(int.parse(json['blockNumber'] as String))
            : const EthBlockNum.pending(),
        transactionIndex = json['transactionIndex'] != null
            ? int.parse(json['transactionIndex'] as String)
            : null,
        from = EthAddress.fromHex(json['from'] as String),
        to = json['to'] != null
            ? EthAddress.fromHex(json['to'] as String)
            : null,
        value = EthAmount.inWei(BigInt.parse(json['value'] as String)),
        gas = int.parse(json['gas'] as String),
        gasPrice = EthAmount.inWei(BigInt.parse(json['gasPrice'] as String)),
        input = hexToBytes(json['input'] as String),
        v = int.parse(json['v'] as String),
        r = hexToBigInt(json['r'] as String),
        s = hexToBigInt(json['s'] as String);

  /// The ECDSA full signature used to sign this transaction.
  MsgSignature get signature => MsgSignature(r!, s!, v!);

  @override
  String toString() {
    return 'EthTransaction{'
        'hash: ${bytesToHex(hash!)}, '
        'nonce: $nonce, '
        'blockHash: ${bytesToHex(blockHash!)}, '
        'blockNumber: $blockNumber, '
        'transactionIndex: $transactionIndex, '
        'from: $from, '
        'to: $to, '
        'value: $value,'
        'gas: $gas, '
        'gasPrice: $gasPrice, '
        'input: ${bytesToHex(input!)}, '
        'v: $v, '
        'r: $r, '
        's: $s}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EthTransaction &&
          runtimeType == other.runtimeType &&
          eq.equals(hash, other.hash) &&
          nonce == other.nonce &&
          eq.equals(blockHash, other.blockHash) &&
          blockNumber == other.blockNumber &&
          transactionIndex == other.transactionIndex &&
          from == other.from &&
          to == other.to &&
          value == other.value &&
          gas == other.gas &&
          gasPrice == other.gasPrice &&
          eq.equals(input, other.input) &&
          v == other.v &&
          r == other.r &&
          s == other.s;

  @override
  int get hashCode =>
      hash.hashCode ^
      nonce.hashCode ^
      blockHash.hashCode ^
      blockNumber.hashCode ^
      transactionIndex.hashCode ^
      from.hashCode ^
      to.hashCode ^
      value.hashCode ^
      gas.hashCode ^
      gasPrice.hashCode ^
      input.hashCode ^
      v.hashCode ^
      r.hashCode ^
      s.hashCode;
}
