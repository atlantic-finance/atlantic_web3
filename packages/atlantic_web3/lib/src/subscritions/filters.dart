import 'package:atlantic_web3/atlantic_web3.dart';

abstract class Filter<T> {
  bool get supportsPubSub => true;

  FilterCreationParams create();

  PubSubCreationParams createPubSub();

  T parseChanges(dynamic log);
}
