import 'package:atlantic_web3_core/atlantic_web3_core.dart';

/// Base classes for generated contracts.
///
/// web3dart can generate contract classes from abi specifications. For more
/// information, see its readme!
abstract class GeneratedContract {
  /// Constructor.
  GeneratedContract(this.self, this.client, this.chainId);

  final DeployedContract self;
  final IWeb3Client client;
  final int? chainId;

  /// Returns whether the [function] has the [expected] selector.
  ///
  /// This is used in an assert in the generated code.
  bool checkSignature(ContractFunction function, String expected) {
    return bytesToHex(function.selector) == expected;
  }

  Future<List<dynamic>> read(
    ContractFunction function,
    List<dynamic> params,
    EthBlockNum? atBlock,
  ) {
    // return client.eth.contract().call(
    //   contract: self,
    //   function: function,
    //   params: params,
    //   atBlock: atBlock,
    // );
    return Future.value([]);
  }

  Future<String> write(
    Credentials credentials,
    EthTransaction2? base,
    ContractFunction function,
    List<dynamic> parameters,
  ) {
    final transaction = base?.copyWith(
          data: function.encodeCall(parameters),
          to: self.address,
        ) ??
        EthTransaction2.callContract(
          contract: self,
          function: function,
          parameters: parameters,
        );

    return client.eth.sendTransaction(
      credentials,
      transaction,
      chainId: chainId,
      fetchChainIdFromNetworkId: chainId == null,
    );
  }
}
