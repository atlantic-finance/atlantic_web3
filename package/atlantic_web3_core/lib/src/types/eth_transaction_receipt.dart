import 'dart:typed_data';

import 'package:atlantic_web3_core/atlantic_web3_core.dart';
import 'package:atlantic_web3_core/src/utils/equality.dart' as eq;

class TransactionReceipt {
  /// Hash of the transaction (32 bytes).
  final Uint8List transactionHash;

  /// Index of the transaction's position in the block.
  final int transactionIndex;

  /// Hash of the block where this transaction is in (32 bytes).
  final Uint8List blockHash;

  /// Block number where this transaction is in.
  final EthBlockNum blockNumber;

  /// Address of the sender.
  final EthAddress? from;

  /// Address of the receiver or `null` if it was a contract creation
  /// transaction.
  final EthAddress? to;

  /// The total amount of gas used when this transaction was executed in the
  /// block.
  final BigInt cumulativeGasUsed;

  /// The amount of gas used by this specific transaction alone.
  final BigInt? gasUsed;

  /// The address of the contract created if the transaction was a contract
  /// creation. `null` otherwise.
  final EthAddress? contractAddress;

  /// Whether this transaction was executed successfully.
  final bool? status;

  /// Array of logs generated by this transaction.
  final List<FilterEvent> logs;

  final EthAmount? effectiveGasPrice;

  TransactionReceipt({
    required this.transactionHash,
    required this.transactionIndex,
    required this.blockHash,
    required this.cumulativeGasUsed,
    this.blockNumber = const EthBlockNum.pending(),
    this.contractAddress,
    this.status,
    this.from,
    this.to,
    this.gasUsed,
    this.effectiveGasPrice,
    this.logs = const [],
  });

  TransactionReceipt.fromJson(Map<String, dynamic> json)
      : transactionHash = hexToBytes(json['transactionHash'] as String),
        transactionIndex = hexToInt(json['transactionIndex'] as String),
        blockHash = hexToBytes(json['blockHash'] as String),
        blockNumber = json['blockNumber'] != null
            ? EthBlockNum.exact(int.parse(json['blockNumber'] as String))
            : const EthBlockNum.pending(),
        from = json['from'] != null
            ? EthAddress.fromHex(json['from'] as String)
            : null,
        to = json['to'] != null
            ? EthAddress.fromHex(json['to'] as String)
            : null,
        cumulativeGasUsed = hexToBigInt(json['cumulativeGasUsed'] as String),
        gasUsed = json['gasUsed'] != null
            ? hexToBigInt(json['gasUsed'] as String)
            : null,
        effectiveGasPrice = json['effectiveGasPrice'] != null
            ? EthAmount.inWei(
                BigInt.parse(json['effectiveGasPrice'] as String),
              )
            : null,
        contractAddress = json['contractAddress'] != null
            ? EthAddress.fromHex(json['contractAddress'] as String)
            : null,
        status = json['status'] != null
            ? (hexToInt(json['status'] as String) == 1)
            : null,
        logs = json['logs'] != null
            ? (json['logs'] as List<dynamic>)
                .map(
                  (dynamic log) =>
                      FilterEvent.fromMap(log as Map<String, dynamic>),
                )
                .toList()
            : [];

  @override
  String toString() {
    return 'TransactionReceipt{'
        'transactionHash: ${bytesToHex(transactionHash)}, '
        'transactionIndex: $transactionIndex, '
        'blockHash: ${bytesToHex(blockHash)}, '
        'blockNumber: $blockNumber, '
        'from: ${from?.hex}, '
        'to: ${to?.hex}, '
        'cumulativeGasUsed: $cumulativeGasUsed, '
        'gasUsed: $gasUsed, '
        'contractAddress: ${contractAddress?.hex}, '
        'status: $status, '
        'effectiveGasPrice: $effectiveGasPrice, '
        'logs: $logs}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionReceipt &&
          runtimeType == other.runtimeType &&
          eq.equals(transactionHash, other.transactionHash) &&
          transactionIndex == other.transactionIndex &&
          eq.equals(blockHash, other.blockHash) &&
          blockNumber == other.blockNumber &&
          from == other.from &&
          to == other.to &&
          cumulativeGasUsed == other.cumulativeGasUsed &&
          gasUsed == other.gasUsed &&
          contractAddress == other.contractAddress &&
          status == other.status &&
          effectiveGasPrice == other.effectiveGasPrice &&
          eq.equals(logs, other.logs);

  @override
  int get hashCode =>
      transactionHash.hashCode ^
      transactionIndex.hashCode ^
      blockHash.hashCode ^
      blockNumber.hashCode ^
      from.hashCode ^
      to.hashCode ^
      cumulativeGasUsed.hashCode ^
      gasUsed.hashCode ^
      contractAddress.hashCode ^
      status.hashCode ^
      effectiveGasPrice.hashCode ^
      logs.hashCode;
}
