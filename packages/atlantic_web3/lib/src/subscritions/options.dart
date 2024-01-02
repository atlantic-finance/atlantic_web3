import 'package:atlantic_web3/atlantic_web3.dart';

/// Options for event filters created with [Web3Client.events].
class FilterOptions {
  FilterOptions({this.fromBlock, this.toBlock, this.address, this.topics});

  FilterOptions.events({
    required DeployedContract contract,
    required ContractEvent event,
    this.fromBlock,
    this.toBlock,
  })  : address = contract.address,
        topics = [
          [bytesToHex(event.signature, padToEvenLength: true, include0x: true)]
        ];

  /// The earliest block which should be considered for this filter. Optional,
  /// the default value is [BlockNum.current].
  ///
  /// Use [BlockNum.current] for the last mined block or
  /// [BlockNum.pending]  for not yet mined transactions.
  final EthBlockNum? fromBlock;

  /// The last block which should be considered for this filter. Optional, the
  /// default value is [BlockNum.current].
  ///
  /// Use [BlockNum.current] for the last mined block or
  /// [BlockNum.pending]  for not yet mined transactions.
  final EthBlockNum? toBlock;

  /// The optional address to limit this filter to. If not null, only logs
  /// emitted from the contract at [address] will be considered. Otherwise, all
  /// log events will be reported.
  final EthAccount? address;

  /// The topics that must be present in the event to be included in this
  /// filter. The topics must be represented as a hexadecimal value prefixed
  /// with "0x". The encoding must have an even number of digits.
  ///
  /// Topics are order-dependent. A transaction with a log with topics \[A, B\]
  /// will be matched by the following topic filters:
  /// - \[\], which matches anything
  /// - \[A\], which matches "A" in the first position and anything after
  /// - \[null, B\], which matches logs that have anything in their first
  ///   position, B in their second position and anything after
  /// - \[A, B\], which matches A in first position, B in second position (and
  /// anything after)
  /// - \[\[A, B\], \[A, B\]\]: Matches (A or B) in first position AND (A or B)
  /// in second position (and anything after).
  ///
  /// The events sent by solidity contracts are encoded like this: The first
  /// topic is the hash of the event signature (except for anonymous events).
  /// All further topics are the encoded values of the indexed parameters of the
  /// event. See https://solidity.readthedocs.io/en/develop/contracts.html#events
  /// for a detailed description.
  final List<List<String>>? topics;
}
