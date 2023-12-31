import 'package:atlantic_web3/atlantic_web3.dart';

/**
 * EN: Class for sending requests over an HTTP JSON-RPC API endpoint to Ethereum
 * clients. This library won't use the accounts feature of clients to use them
 * to create transactions, you will instead have to obtain private keys of
 * accounts yourself.
 *
 * ES: Clase para enviar solicitudes a través de un extremo de API HTTP JSON-RPC
 * a clientes de Ethereum. Esta biblioteca no usará la función de cuentas de los
 * clientes para usarlas para crear transacciones, sino que tendrá que obtener
 * las claves privadas de las cuentas usted mismo.
 */
class Web3Client implements IWeb3Client {
  // Principal
  late final String _name;
  late final String _version;
  BaseProvider? _provider;

  // Modules
  late final IWeb3Blockchain _eth;

  // Instancia privada
  static Web3Client? _instance = null;

  static IWeb3Client get instance {
    if (_instance == null) {
      throw new AssertionError('You must initialize the Web3Client instance before calling Web3Client.instance');
    }
    return _instance!;
  }

  static Future<IWeb3Client> initialize({required String name, required BaseProvider provider,}) async {
    if (_instance == null) {
       _instance = Web3Client._(name, provider);
    } else {
      throw new AssertionError('This instance is already initialized');
    }
    return _instance!;
  }

  // ignore: sort_constructors_first
  Web3Client._(String name, BaseProvider provider) {
    // Principal
    this._name = name;
    this._version = 'v0.0.1';
    this._provider = provider;
    // Modules
    //this._eth = Web3Eth(_provider!);
  }

  @override
  IWeb3Blockchain get eth => _eth;

  @override
  String get name => _name;

  @override
  String get version => _version;

  @override
  BaseProvider get defaultProvider => _provider!;
}
