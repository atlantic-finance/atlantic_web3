import 'package:atlantic_web3_core/atlantic_web3_core.dart';

class Web3ABI implements IWeb3Abi {
  // Principal
  late final BaseProvider _provider;
  late final FilterEngine _filters;

  Web3ABI(BaseProvider provider) {
    // Principal
    this._provider = provider;
    this._filters = FilterEngine(_provider);
  }

  @override
  Future<List<dynamic>> getCompilers() async {
    return await _provider.request('eth_getCompilers', []);
  }

  @override
  Future<String> compilerSolidity(String source) async {
    return await _provider.request('eth_compileSolidity', [source]);
  }

  @override
  Future<String> compilerLLL(String source) async {
    return await _provider.request('eth_compileLLL', [source]);
  }

  @override
  Future<String> compilerSerpent(String source) async {
    return await _provider.request('eth_compileSerpent', [source]);
  }
}
