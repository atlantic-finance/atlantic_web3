import 'package:atlantic_web3_core/atlantic_web3_core.dart';

class PendingTransactionsFilter extends Filter<String> {
  @override
  bool get supportsPubSub => false;

  @override
  FilterCreationParams create() {
    return FilterCreationParams('eth_newPendingTransactionFilter', []);
  }

  @override
  String parseChanges(dynamic log) {
    return log as String;
  }

  @override
  PubSubCreationParams createPubSub() {
    return PubSubCreationParams(List.empty());
  }
}
