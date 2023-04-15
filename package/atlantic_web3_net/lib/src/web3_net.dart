import 'package:atlantic_web3_core/atlantic_web3_core.dart';

class Web3Net implements IWeb3Net {
  late final BaseProvider _provider;

  Web3Net(this._provider);

  /// Returns the id of the network the client is currently connected to.
  ///
  /// In a non-private network, the network ids usually correspond to the
  /// following networks:
  /// 1: Ethereum Mainnet
  /// 2: Morden Testnet (deprecated)
  /// 3: Ropsten Testnet
  /// 4: Rinkeby Testnet
  /// 42: Kovan Testnet
  /// 5777: Ganache Testnet
  Future<int> getNetworkId() {
    return _provider.request<String>('net_version').then(int.parse);
  }

  /// Returns true if the node is actively listening for network connections.
  Future<bool> isListeningForNetwork() {
    return _provider.request<bool>('net_listening');
  }

  /// Returns the amount of Ethereum nodes currently connected to the client.
  Future<int> getPeerCount() async {
    return _provider.request<int>('net_peerCount');
  }
}
