import 'package:atlantic_web3_core/atlantic_web3_core.dart';

class Web3Accounts implements IWeb3Accounts {
  // Principal
  late final BaseProvider _provider;
  late final FilterEngine _filters;

  Web3Accounts(BaseProvider provider) {
    // Principal
    this._provider = provider;
    this._filters = FilterEngine(_provider);
  }
}
