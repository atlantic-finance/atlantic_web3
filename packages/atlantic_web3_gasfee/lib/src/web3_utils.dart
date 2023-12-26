import 'package:atlantic_web3_core/atlantic_web3_core.dart';

class Web3Utils {
  final BaseProvider _provider;

  Web3Utils(this._provider);

  Future<bool> isListeningForNetwork() {
    return _provider.request('net_listening');
  }
}
