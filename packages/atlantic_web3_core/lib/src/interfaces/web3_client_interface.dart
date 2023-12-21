import 'package:atlantic_web3_core/atlantic_web3_core.dart';

abstract class IWeb3Client {
  IWeb3Blockchain get eth;

  IWeb3Authentication get auth;
  //
  // IWeb3Utils get utils;

  String get name;

  String get version;
}
