import 'package:atlantic_web3/atlantic_web3.dart';

class LogsFilter extends Filter<FilterEvent> {
  FilterOptions? options;

  @override
  FilterCreationParams create() {
    return FilterCreationParams('eth_getLogs', [createParamsObject(true)]);
  }

  @override
  PubSubCreationParams createPubSub() {
    // TODO: implement createPubSub
    throw UnimplementedError();
  }

  dynamic createParamsObject(bool includeFromAndTo) {
    final encodedOptions = <String, dynamic>{};
    if (options?.fromBlock != null && includeFromAndTo) {
      encodedOptions['fromBlock'] = options?.fromBlock?.toBlockParam();
    }
    if (options?.toBlock != null && includeFromAndTo) {
      encodedOptions['toBlock'] = options?.toBlock?.toBlockParam();
    }
    if (options?.address != null) {
      encodedOptions['address'] = options?.address?.hex;
    }
    if (options?.topics != null) {
      final topics = <dynamic>[];
      options?.topics?.forEach((e) => topics.add(e.isEmpty ? null : e));
      encodedOptions['topics'] = topics;
    }

    return encodedOptions;
  }

  @override
  FilterEvent parseChanges(log) {
    // TODO: implement parseChanges
    throw UnimplementedError();
  }
}
