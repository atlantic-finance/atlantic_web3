import 'package:atlantic_web3_core/atlantic_web3_core.dart';

abstract class IWeb3Client {
  // Modulos
  IWeb3Passkey get passkey;
  IWeb3Authentication get auth;
  IWeb3Blockchain get eth;

  // Local
  String get name;
  String get version;
}
