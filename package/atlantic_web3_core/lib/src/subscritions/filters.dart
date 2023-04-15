import 'package:atlantic_web3_core/atlantic_web3_core.dart';

abstract class Filter<T> {
  bool get supportsPubSub => true;

  FilterCreationParams create();

  PubSubCreationParams createPubSub();

  T parseChanges(dynamic log);
}
