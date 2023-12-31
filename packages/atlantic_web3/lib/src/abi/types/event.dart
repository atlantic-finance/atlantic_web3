import 'dart:typed_data';

import 'package:atlantic_web3/atlantic_web3.dart';

/// An event that can be emitted by a smart contract during a transaction.
class ContractEvent {
  /// Name.
  final String name;

  /// Whether this events was declared as anonymous in solidity.
  final bool anonymous;

  /// A list of types that represent the parameters required to call this
  /// function.
  final List<EventParameter> inputs;

  /// Constructor.
  ContractEvent(this.name, this.anonymous, this.inputs);

  /// The user-visible signature of this event, consisting of its name and the
  /// type of its parameters.
  String get stringSignature {
    final parameters = inputs.map((c) => c.name).join(',');
    //return '$name(${_encodeParameters(type)})';
    return parameters;
  }

  /// The signature of this event, which is the keccak hash of the event's name
  /// followed by it's components.
  late final Uint8List signature = keccakUtf8(stringSignature);

  /// Decodes the fields of this event from the event's [topics] and its [data]
  /// payload.
  ///
  /// [inputs] of this event which are [EventParameter.indexed] will be
  /// read from the topics, whereas non-indexed components will be read from the
  /// data section of the event.
  /// Indexed parameters which would take more than 32 bytes to encode are not
  /// included in the result. Apart from that, the order of the data returned
  /// is identical to the order of the [inputs].
  List<dynamic> decodeResults(List<String> topics, String data) {
    final topicOffset = anonymous ? 0 : 1;

    // non-indexed parameters are decoded like a tuple
    final notIndexed =
        inputs.where((c) => !c.indexed).map((c) => c.type).toList();
    final tuple = TupleType(notIndexed);

    final decodedNotIndexed = tuple.decode(hexToBytes(data).buffer, 0).data;

    // Merge indexed components (which are encoded as topics) and non-indexed
    // components (which were already decoded in decodedNotIndexed) together
    // into the result list.
    var dataIndex = 0;
    var topicIndex = topicOffset;

    final result = [];
    for (final component in inputs) {
      if (component.indexed) {
        // components that are bigger than 32 bytes when decoded, or have a
        // dynamic type, are not included in [topics]. A hash of the data will
        // be included instead. We can't decode these, so they will be skipped.
        final length = component.type.encodingLength;
        if (length.isDynamic || length.length! > 32) {
          topicIndex++;
          continue;
        }

        final topicBuffer = hexToBytes(topics[topicIndex]).buffer;
        result.add(component.type.decode(topicBuffer, 0).data);

        topicIndex++;
      } else {
        result.add(decodedNotIndexed[dataIndex]);
        dataIndex++;
      }
    }

    return result;
  }
}
