import 'package:atlantic_web3/atlantic_web3.dart';

abstract class IWeb3Client {
  // Modulos
  IWeb3Blockchain get eth;

  // Local
  String get name;
  String get version;
  BaseProvider get defaultProvider;
}
