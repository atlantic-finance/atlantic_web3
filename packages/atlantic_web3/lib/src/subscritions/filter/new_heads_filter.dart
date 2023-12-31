import 'package:atlantic_web3/atlantic_web3.dart';

class NewHeadFilter extends Filter<String> {
  @override
  bool get supportsPubSub => false;

  @override
  FilterCreationParams create() {
    return FilterCreationParams('eth_newBlockFilter', []);
  }

  @override
  String parseChanges(dynamic log) {
    return log as String;
  }

  @override
  PubSubCreationParams createPubSub() {
    // the pub-sub subscription for new blocks isn't universally supported by
    // ethereum nodes, so let's not implement it just yet.
    return PubSubCreationParams(List.empty());
  }
}
