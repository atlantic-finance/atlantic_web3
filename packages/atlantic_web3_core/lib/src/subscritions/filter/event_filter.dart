import 'package:atlantic_web3_core/atlantic_web3_core.dart';

class EventFilter extends Filter<FilterEvent> {
  EventFilter(this.options);

  final FilterOptions options;

  @override
  FilterCreationParams create() {
    return FilterCreationParams('eth_newFilter', [createParamsObject(true)]);
  }

  @override
  PubSubCreationParams createPubSub() {
    return PubSubCreationParams([
      'logs',
      createParamsObject(false),
    ]);
  }

  dynamic createParamsObject(bool includeFromAndTo) {
    final encodedOptions = <String, dynamic>{};
    if (options.fromBlock != null && includeFromAndTo) {
      encodedOptions['fromBlock'] = options.fromBlock?.toBlockParam();
    }
    if (options.toBlock != null && includeFromAndTo) {
      encodedOptions['toBlock'] = options.toBlock?.toBlockParam();
    }
    if (options.address != null) {
      encodedOptions['address'] = options.address?.hex;
    }
    if (options.topics != null) {
      final topics = <dynamic>[];
      options.topics?.forEach((e) => topics.add(e.isEmpty ? null : e));
      encodedOptions['topics'] = topics;
    }

    return encodedOptions;
  }

  @override
  FilterEvent parseChanges(dynamic log) {
    return FilterEvent.fromMap(log as Map<String, dynamic>);
  }
}
