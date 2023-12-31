import 'dart:typed_data';

import 'package:atlantic_web3/atlantic_web3.dart';
import 'package:atlantic_web3/src/utils/equality.dart' as eq;

class EthBlock {
  final EthBlockNum? number;
  final Uint8List? hash;
  final Uint8List? parentHash;
  final String? mixHash;
  final Integer? nonce;
  final String? sha3Uncles;
  final String? logsBloom;
  final String? transactionsRoot;
  final String? stateRoot;
  final String? receiptsRoot;
  final String? miner;
  final Integer? difficulty;
  final Integer? totalDifficulty;
  final String? extraData;
  final BigInteger? size;
  final EthAmount? gasLimit;
  final EthAmount? gasUsed;
  final DateTime? timestamp;
  final List<EthTransaction>? transactions;
  final List<dynamic>? uncles;

  final EthAmount? baseFeePerGas;

  EthBlock({
    this.number,
    this.hash,
    this.parentHash,
    this.mixHash,
    this.nonce,
    this.sha3Uncles,
    this.logsBloom,
    this.transactionsRoot,
    this.stateRoot,
    this.receiptsRoot,
    this.miner,
    this.difficulty,
    this.totalDifficulty,
    this.extraData,
    this.size,
    this.gasLimit,
    this.gasUsed,
    this.timestamp,
    this.transactions,
    this.uncles,
    this.baseFeePerGas,
  });

  EthBlock.fromJson(Map<String, dynamic> json)
      : number = json['number'] != null
            ? EthBlockNum.exact(int.parse(json['number'] as String))
            : const EthBlockNum.pending(),
        hash = hexToBytes(json['hash'] as String),
        parentHash = hexToBytes(json['parentHash'] as String),
        mixHash = json['mixHash'] as String?,
        nonce = hexToInt(json['nonce'] as String),
        sha3Uncles = json['sha3Uncles'] as String?,
        logsBloom = json['logsBloom'] as String?,
        transactionsRoot = json['transactionsRoot'] as String?,
        stateRoot = json['stateRoot'] as String?,
        receiptsRoot = json['receiptsRoot'] as String?,
        miner = json['miner'] as String?,
        difficulty = hexToInt(json['difficulty'] as String),
        totalDifficulty = hexToInt(json['totalDifficulty'] as String),
        extraData = json['extraData'] as String?,
        size = hexToBigInt(json['size'] as String),
        gasLimit = EthAmount.inWei(BigInt.parse(json['gasLimit'] as String)),
        gasUsed = EthAmount.inWei(BigInt.parse(json['gasUsed'] as String)),
        timestamp = DateTime.fromMillisecondsSinceEpoch(
          hexToInt(json['timestamp'] as String) * 1000,
          isUtc: true,
        ),
        transactions = (json['transactions'] as List<dynamic>)
            .map((e) => e as Map<String, dynamic>)
            .map((e) => EthTransaction.fromJson(e))
            .toList(),
        uncles = (json['uncles'] as List<dynamic>),
        baseFeePerGas = json.containsKey('baseFeePerGas')
            ? EthAmount.fromBigInt(
                EthUnit.wei,
                hexToBigInt(json['baseFeePerGas'] as String),
              )
            : null;

  bool get isSupportEIP1559 => baseFeePerGas != null;

  @override
  String toString() {
    return 'EthBlock{'
        'number: $number, '
        'hash: ${bytesToHex(hash!)}, '
        'parentHash: ${bytesToHex(parentHash!)}, '
        'mixHash: $mixHash, '
        'nonce: $nonce, '
        'sha3Uncles: $sha3Uncles, '
        'logsBloom: $logsBloom, '
        'transactionsRoot: $transactionsRoot, '
        'stateRoot: $stateRoot,'
        'miner: $miner, '
        'difficulty: $difficulty, '
        'totalDifficulty: $totalDifficulty, '
        'extraData: $extraData, '
        'size: $size, '
        'gasLimit: $gasLimit, '
        'gasUsed: $gasUsed, '
        'timestamp: $timestamp, '
        'transactions: $transactions, '
        'uncles: $uncles}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EthBlock &&
          runtimeType == other.runtimeType &&
          number == other.number &&
          eq.equals(hash, other.hash) &&
          eq.equals(parentHash, other.parentHash) &&
          mixHash == other.mixHash &&
          nonce == other.nonce &&
          sha3Uncles == other.sha3Uncles &&
          logsBloom == other.logsBloom &&
          transactionsRoot == other.transactionsRoot &&
          stateRoot == other.stateRoot &&
          miner == other.miner &&
          difficulty == other.difficulty &&
          totalDifficulty == other.totalDifficulty &&
          extraData == other.extraData &&
          size == other.size &&
          gasLimit == other.gasLimit &&
          gasUsed == other.gasUsed &&
          timestamp == other.timestamp &&
          eq.equals(transactions, other.transactions) &&
          eq.equals(uncles, other.uncles) &&
          baseFeePerGas == other.baseFeePerGas;

  @override
  int get hashCode =>
      number.hashCode ^
      hash.hashCode ^
      parentHash.hashCode ^
      mixHash.hashCode ^
      nonce.hashCode ^
      sha3Uncles.hashCode ^
      logsBloom.hashCode ^
      transactionsRoot.hashCode ^
      stateRoot.hashCode ^
      miner.hashCode ^
      difficulty.hashCode ^
      totalDifficulty.hashCode ^
      extraData.hashCode ^
      size.hashCode ^
      gasLimit.hashCode ^
      gasUsed.hashCode ^
      timestamp.hashCode ^
      transactions.hashCode ^
      uncles.hashCode ^
      baseFeePerGas.hashCode;
}
