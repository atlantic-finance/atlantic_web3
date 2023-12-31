import 'package:atlantic_web3/atlantic_web3.dart';
import 'package:atlantic_web3/src/utils/equality.dart' as eq;

/// A log event emitted in a transaction.
class FilterEvent {
  FilterEvent({
    this.removed,
    this.logIndex,
    this.transactionIndex,
    this.transactionHash,
    this.blockHash,
    this.blockNum,
    this.address,
    this.data,
    this.topics,
  });

  FilterEvent.fromMap(Map<String, dynamic> log)
      : removed = log['removed'] as bool? ?? false,
        logIndex = log['logIndex'] != null
            ? hexToBigInt(log['logIndex'] as String).toInt()
            : null,
        transactionIndex = log['transactionIndex'] != null
            ? hexToBigInt(log['transactionIndex'] as String).toInt()
            : null,
        transactionHash = log['transactionHash'] != null
            ? log['transactionHash'] as String
            : null,
        blockHash =
            log['blockHash'] != null ? log['blockHash'] as String : null,
        blockNum = log['blockNumber'] != null
            ? hexToBigInt(log['blockNumber'] as String).toInt()
            : null,
        address = EthAddress.fromHex(log['address'] as String),
        data = log['data'] as String?,
        topics = (log['topics'] as List?)?.cast<String>();

  /// Whether the log was removed, due to a chain reorganization. False if it's
  /// a valid log.
  final bool? removed;

  /// Log index position in the block. `null` when the transaction which caused
  /// this log has not yet been mined.
  final int? logIndex;

  /// Transaction index position in the block.
  /// `null` when the transaction which caused this log has not yet been mined.
  final int? transactionIndex;

  /// Hash of the transaction which caused this log. `null` when it's pending.
  final String? transactionHash;

  /// Hash of the block where this log was in. `null` when it's pending.
  final String? blockHash;

  /// The block number of the block where this log was in. `null` when it's
  /// pending.
  final int? blockNum;

  /// The address (of the smart contract) from which this log originated.
  final EthAddress? address;

  /// The data blob of this log, hex-encoded.
  ///
  /// For solidity events, this contains all non-indexed parameters of the
  /// event.
  final String? data;

  /// The topics of this event, hex-encoded.
  ///
  /// For solidity events, the first topic is a hash of the event signature
  /// (except for anonymous events). All further topics are the encoded
  /// values of indexed parameters.
  final List<String>? topics;

  @override
  String toString() {
    return 'FilterEvent('
        'removed=$removed,'
        'logIndex=$logIndex,'
        'transactionIndex=$transactionIndex,'
        'transactionHash=$transactionHash,'
        'blockHash=$blockHash,'
        'blockNum=$blockNum,'
        'address=$address,'
        'data=$data,'
        'topics=$topics'
        ')';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FilterEvent &&
          runtimeType == other.runtimeType &&
          removed == other.removed &&
          logIndex == other.logIndex &&
          transactionIndex == other.transactionIndex &&
          transactionHash == other.transactionHash &&
          blockHash == other.blockHash &&
          blockNum == other.blockNum &&
          address == other.address &&
          data == other.data &&
          eq.equals(topics, other.topics);

  @override
  int get hashCode =>
      removed.hashCode ^
      logIndex.hashCode ^
      transactionIndex.hashCode ^
      transactionHash.hashCode ^
      blockHash.hashCode ^
      blockNum.hashCode ^
      address.hashCode ^
      data.hashCode ^
      topics.hashCode;
}
