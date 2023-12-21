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
  late final String _version;
  late final BaseProvider _provider;

  // Modules
  late final IWeb3Eth _eth;
  // late final IWeb3Net _net;
  // late final IWeb3Utils _utils;

  /// Starts a client that connects to a JSON rpc API, available at [url]. The
  /// [httpClient] will be used to send requests to the rpc server.
  /// Am isolate will be used to perform expensive operations, such as signing
  /// transactions or computing private keys.
  // ignore: sort_constructors_first
  Web3Client(BaseProvider provider) {
    // Principal
    this._version = 'v0.0.1';
    this._provider = provider;
    // Modules
    this._eth = Web3Eth(_provider);
    // this._net = Web3Net(_provider);
    // this._utils = Web3Utils(_provider);
  }

  @override
  IWeb3Eth get eth => _eth;

  // @override
  // IWeb3Net get net => _net;
  //
  // @override
  // IWeb3Utils get utils => _utils;

  @override
  String get version => _version;
}
