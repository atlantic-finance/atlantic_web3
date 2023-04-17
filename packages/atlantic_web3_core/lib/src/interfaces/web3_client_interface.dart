import 'package:atlantic_web3_core/atlantic_web3_core.dart';

abstract class IWeb3Client {
  IWeb3Eth get eth;

  IWeb3Net get net;

  IWeb3Utils get utils;

  String get version;
}
