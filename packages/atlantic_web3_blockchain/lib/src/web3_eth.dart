import 'dart:typed_data';

import 'package:atlantic_web3_core/atlantic_web3_core.dart' as rlp;
import 'package:atlantic_web3_core/atlantic_web3_core.dart';

class Web3Eth implements IWeb3Eth {
  static const EthBlockNum _defaultBlock = EthBlockNum.current();

  // Principal
  late final BaseProvider _provider;
  late final FilterEngine _filters;



  Web3Eth(BaseProvider provider) {
    // Principal
    this._provider = provider;
    this._filters = FilterEngine(_provider);
  }

  String _getBlockParam(EthBlockNum? block) {
    return (block ?? _defaultBlock).toBlockParam();
  }


  // IWeb3Contract contract(
  //         BaseProvider provider, ContractAbi abi, EthAddress address) =>
  //     Web3Contract(_provider, abi, address);

  /// Constructs a new [Credentials] with the provided [privateKey] by using
  /// an [EthPrivateKey].
  @override
  Future<EthPrivateKey> credentialsFromPrivateKey(String privateKey) {
    return Future.value(EthPrivateKey.fromHex(privateKey));
  }

  /// Estimate the amount of gas that would be necessary if the transaction was
  /// sent via [sendTransaction]. Note that the estimate may be significantly
  /// higher than the amount of gas actually used by the transaction.
  @override
  Future<BigInt> estimateGas(EthTransaction transaction) async {
    final amountHex = await _provider.request<String>(
      'eth_estimateGas',
      [
        {
          if (transaction.from != null) 'from': transaction.from!.hex,
          if (transaction.to != null) 'to': transaction.to!.hex,
          if (transaction.value != null)
            'value': '0x${transaction.value!.getInWei.toRadixString(16)}',
          if (transaction.gas != null)
            'gas': '0x${transaction.gas!.toRadixString(16)}',
          if (transaction.gasPrice != null)
            'gasPrice': '0x${transaction.gasPrice!.getInWei.toRadixString(16)}',
          if (transaction.input != null)
            'input':
                bytesToHex(transaction.input as List<int>, include0x: true),
        },
      ],
    );
    return hexToBigInt(amountHex);
  }

  @override
  @Deprecated('Deprecated estimateGas2() use estimateGas()')
  Future<BigInt> estimateGas2({
    EthAddress? from,
    EthAddress? to,
    EthAmount? value,
    BigInt? gas,
    EthAmount? gasPrice,
    EthAmount? maxPriorityFeePerGas,
    EthAmount? maxFeePerGas,
    Uint8List? data,
  }) async {
    final amountHex = await _provider.request<String>(
      'eth_estimateGas',
      [
        {
          if (from != null) 'from': from.hex,
          if (to != null) 'to': to.hex,
          if (value != null) 'value': '0x${value.getInWei.toRadixString(16)}',
          if (gas != null) 'gas': '0x${gas.toRadixString(16)}',
          if (gasPrice != null)
            'gasPrice': '0x${gasPrice.getInWei.toRadixString(16)}',
          if (maxPriorityFeePerGas != null)
            'maxPriorityFeePerGas':
                '0x${maxPriorityFeePerGas.getInWei.toRadixString(16)}',
          if (maxFeePerGas != null)
            'maxFeePerGas': '0x${maxFeePerGas.getInWei.toRadixString(16)}',
          if (data != null) 'data': bytesToHex(data, include0x: true),
        },
      ],
    );
    return hexToBigInt(amountHex);
  }

  @override
  Future<List<dynamic>> getAccounts() async {
    return await _provider.request('eth_accounts', []);
  }

  /// Gets the balance of the account with the specified address.
  ///
  /// This function allows specifying a custom block mined in the past to get
  /// historical data. By default, [BlockNum.current] will be used.
  @override
  Future<EthAmount> getBalance(EthAddress address,
      {EthBlockNum? atBlock}) async {
    final blockParam = _getBlockParam(atBlock);
    final data = await _provider.request<String>(
      'eth_getBalance',
      [address.hex, blockParam],
    );
    return EthAmount.fromBigInt(EthUnit.wei, hexToBigInt(data));
  }

  @override
  Future<EthBlock> getBlock({
    EthBlockNum atBlock = const EthBlockNum.current(),
    Boolean isContainFullObj = true,
  }) async {
    final blockParam = _getBlockParam(atBlock);
    final json = await _provider.request<Map<String, dynamic>>(
      'eth_getBlockByNumber',
      [blockParam, isContainFullObj],
    );
    return EthBlock.fromJson(json);
  }

  /// Returns the number of the most recent block on the chain.
  @override
  Future<int> getBlockNumber() {
    return _provider
        .request<String>('eth_blockNumber')
        .then((s) => hexToBigInt(s).toInt());
  }

  @override
  Future<int> getBlockTransactionCount(
      {EthBlockNum atBlock = const EthBlockNum.current()}) {
    final blockParam = _getBlockParam(atBlock);
    return _provider.request<String>(
      'eth_getBlockTransactionCountByNumber',
      [blockParam],
    ).then((s) => hexToBigInt(s).toInt());
  }

  @override
  Future<int> getBlockUncleCount(
      {EthBlockNum atBlock = const EthBlockNum.current()}) {
    final blockParam = _getBlockParam(atBlock);
    return _provider.request<String>(
      'eth_getUncleCountByBlockNumber',
      [blockParam],
    ).then((s) => hexToBigInt(s).toInt());
  }

  @override
  Future<BigInt> getChainId() {
    return _provider.request<String>('eth_chainId').then(BigInt.parse);
  }

  /// Returns the version of the client we're sending requests to.
  @override
  Future<String> getClientVersion() {
    return _provider.request('web3_clientVersion');
  }

  /**
   * Returns the coinbase address to which mining rewards will go.
   *
   * ```dart
   * web3.eth.getCoinbase()
   *   .then(print);
   *   > "0x11f4d0A3c12e86B4b5F39B213F7E19D048276DAe"
   * ```
   */
  @override
  Future<EthAddress> getCoinbase() async {
    final hex = await _provider.request<String>('eth_coinbase');
    return EthAddress.fromHex(hex);
  }

  /// Returns the amount of Ether typically needed to pay for one unit of gas.
  ///
  /// Although not strictly defined, this value will typically be a sensible
  /// amount to use.
  @override
  Future<EthAmount> getGasPrice() async {
    final data = await _provider.request<String>('eth_gasPrice');
    return EthAmount.fromBigInt(EthUnit.wei, hexToBigInt(data));
  }

  /// Returns the amount of hashes per second the connected node is mining with.
  @override
  Future<int> getHashRate() {
    return _provider
        .request<String>('eth_hashrate')
        .then((s) => hexToBigInt(s).toInt());
  }

  /// Returns the version of the Ethereum-protocol the client is using.
  @override
  Future<int> getProtocolVersion() async {
    final hex = await _provider.request<String>('eth_protocolVersion');
    return hexToBigInt(hex).toInt();
  }

  /// Returns an object indicating whether the node is currently synchronising
  /// with its network.
  ///
  /// If so, progress information is returned via [EthSyncInformation].
  @override
  Future<EthSyncInformation?> getSyncStatus() async {
    final data = await _provider.request<dynamic>('eth_syncing');

    if (data is Map) {
      print(data);
      final startingBlock =
          hexToBigInt(data['startingBlock'] as String).toInt();
      final currentBlock = hexToBigInt(data['currentBlock'] as String).toInt();
      final highestBlock = hexToBigInt(data['highestBlock'] as String).toInt();

      return EthSyncInformation(startingBlock, currentBlock, highestBlock);
    } else {
      return null;
    }
  }

  /// Returns the information about a transaction requested by transaction hash
  /// [txHash].
  @override
  Future<EthTransaction?> getTransaction(
    String txHash,
  ) async {
    final map = await _provider.request<Map<String, dynamic>?>(
      'eth_getTransactionByHash',
      [txHash],
    );
    if (map == null) return null;
    return EthTransaction.fromJson(map);
  }

  /// Gets the amount of transactions issued by the specified [address].
  ///
  /// This function allows specifying a custom block mined in the past to get
  /// historical data. By default, [BlockNum.current] will be used.
  @override
  Future<int> getTransactionCount(
    EthAddress address, {
    EthBlockNum? atBlock,
  }) {
    final blockParam = _getBlockParam(atBlock);

    return _provider.request<String>(
      'eth_getTransactionCount',
      [address.hex, blockParam],
    ).then((hex) => hexToBigInt(hex).toInt());
  }

  @override
  Future<EthTransaction?> getTransactionFromBlock(
      EthBlockNum? atBlock, int index) async {
    final blockParam = _getBlockParam(atBlock);
    final map = await _provider.request<Map<String, dynamic>?>(
      'eth_getTransactionByBlockNumberAndIndex',
      [blockParam, index],
    );
    if (map == null) return null;
    return EthTransaction.fromJson(map);
  }

  /// Returns an receipt of a transaction based on its hash.
  @override
  Future<TransactionReceipt?> getTransactionReceipt(String txHash) async {
    final map = await _provider.request<Map<String, dynamic>?>(
      'eth_getTransactionReceipt',
      [txHash],
    );
    print(map);
    if (map == null) return null;
    return TransactionReceipt.fromJson(map);
  }

  @override
  dynamic getUncleFromBlock(EthBlockNum? atBlock, int index) async {
    final blockParam = _getBlockParam(atBlock);
    final map = await _provider.request<Map<String, dynamic>?>(
      'eth_getUncleByBlockNumberAndIndex',
      [blockParam, index],
    );
    if (map == null) return null;
    return map;
  }

  @override
  Future<List<dynamic>> getWork(
      {EthBlockNum atBlock = const EthBlockNum.current()}) async {
    final blockParam = _getBlockParam(atBlock);
    return await _provider.request('eth_getWork', [blockParam]);
  }

  /// Returns true if the connected client is currently mining, false if not.
  @override
  Future<bool> isMining() async {
    return _provider.request('eth_mining');
  }

  @override
  Future<bool> isSyncing() async {
    final data = await _provider.request<dynamic>('eth_syncing');
    if (data is Map) {
      return true;
    } else {
      return false;
    }
  }

  /// Listens for logs emitted from transactions. The [options] can be used to
  /// apply additional filters.
  ///
  /// {@macro web3dart:filter_streams_behavior}
  /// See also:
  /// - https://solidity.readthedocs.io/en/develop/contracts.html#events, which
  /// explains more about how events are encoded.
  @override
  Stream<FilterEvent> events(FilterOptions options) {
    /*
    if (_socketConnector != null) {
      // The real-time rpc nodes don't support listening to old data, so handle
      // that here.
      return Stream.fromFuture(getPastLogs(options))
          .expand((e) => e)
          .followedBy(_filters.addFilter(EventFilter(options)));
    }
    */
    return _filters.addFilter(EventFilter(options));
  }

  /// Returns all logs matched by the filter in [options].
  ///
  /// See also:
  ///  - [events], which can be used to obtain a stream of log events
  ///  - https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_getlogs
  @override
  Stream<FilterEvent> eventsLogs() {
    return _filters.addFilter(LogsFilter());
  }

  /// Listens for new blocks that are added to the chain. The stream will emit
  /// the hexadecimal hash of the block after it has been added.
  ///
  /// {@template web3dart:filter_streams_behavior}
  /// The stream can only be listened to once. The subscription must be disposed
  /// properly when no longer used. Failing to do so causes a memory leak in
  /// your application and uses unnecessary resources on the connected node.
  /// {@endtemplate}
  /// See also:
  /// - [hexToBytes] and [hexToBigInt], which can transform hex strings into a byte
  /// or integer representation.
  @override
  Stream<String> eventsNewHeads() {
    return _filters.addFilter(NewHeadFilter());
  }

  /// Listens for pending transactions as they are received by the connected
  /// node. The stream will emit the hexadecimal hash of the pending
  /// transaction.
  ///
  /// {@macro web3dart:filter_streams_behavior}
  /// See also:
  /// - [hexToBytes] and [hexToBigInt], which can transform hex strings into a byte
  /// or integer representation.
  @override
  Stream<String> getPendingTransactions() {
    return _filters.addFilter(PendingTransactionsFilter());
  }

  @override
  Stream<String> eventsNewPendingTransactions() {
    return _filters.addFilter(PendingTransactionsFilter());
  }

  /// Closes resources managed by this client, such as the optional background
  /// isolate for calculations and managed streams.
  @override
  Future<void> cleanEvent() async {
    await _filters.dispose();
    await _provider.dispose();
  }

  /*
  Para manejar transacciones no se puede mover por temas de dependencias
   */

  /// Signs the given transaction using the keys supplied in the [cred]
  /// object to upload it to the client so that it can be executed.
  ///
  /// Returns a hash of the transaction which, after the transaction has been
  /// included in a mined block, can be used to obtain detailed information
  /// about the transaction.
  Future<String> sendTransaction(
    Credentials cred,
    EthTransaction2 transaction, {
    int? chainId = 1,
    bool fetchChainIdFromNetworkId = false,
  }) async {
    if (cred is CustomTransactionSender) {
      return cred.sendTransaction(transaction);
    }

    var signed = await signTransaction(
      cred,
      transaction,
      chainId: chainId,
      fetchChainIdFromNetworkId: fetchChainIdFromNetworkId,
    );

    if (transaction.isEIP1559) {
      signed = prependTransactionType(0x02, signed);
    }

    return sendRawTransaction(signed);
  }

  /// Signs the [transaction] with the credentials [cred]. The transaction will
  /// not be sent.
  ///
  /// See also:
  ///  - [bytesToHex], which can be used to get the more common hexadecimal
  /// representation of the transaction.
  Future<Uint8List> signTransaction(
    Credentials cred,
    EthTransaction2 transaction, {
    int? chainId = 1,
    bool fetchChainIdFromNetworkId = false,
  }) async {
    final signingInput = await _fillMissingData(
      credentials: cred,
      transaction: transaction,
      chainId: chainId,
      loadChainIdFromNetwork: fetchChainIdFromNetworkId,
      client: this,
    );

    return _signTransaction(
      signingInput.transaction,
      signingInput.credentials,
      signingInput.chainId,
    );
  }

  /// Sends a raw, signed transaction.
  ///
  /// To obtain a transaction in a signed form, use [signTransaction].
  ///
  /// Returns a hash of the transaction which, after the transaction has been
  /// included in a mined block, can be used to obtain detailed information
  /// about the transaction.
  Future<String> sendRawTransaction(Uint8List signedTransaction) async {
    return _provider.request('eth_sendRawTransaction', [
      bytesToHex(signedTransaction, include0x: true, padToEvenLength: true)
    ]);
  }

  @override
  BaseProvider getDefaultProvider() {
    return _provider;
  }

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

  Future<_SigningInput> _fillMissingData({
    required Credentials credentials,
    required EthTransaction2 transaction,
    int? chainId,
    bool loadChainIdFromNetwork = false,
    Web3Eth? client,
  }) async {
    if (loadChainIdFromNetwork && chainId != null) {
      throw ArgumentError(
        "You can't specify loadChainIdFromNetwork and specify a custom chain id!",
      );
    }

    final sender = transaction.from ?? credentials.address;
    var gasPrice = transaction.gasPrice;

    if (client == null &&
        (transaction.nonce == null ||
            transaction.gas == null ||
            loadChainIdFromNetwork ||
            (!transaction.isEIP1559 && gasPrice == null))) {
      throw ArgumentError('Client is required to perform network actions');
    }

    if (!transaction.isEIP1559 && gasPrice == null) {
      gasPrice = await client!.getGasPrice();
    }

    final nonce = transaction.nonce ??
        await client!
            .getTransactionCount(sender, atBlock: const EthBlockNum.pending());

    final maxGas = transaction.gas ??
        await client!
            .estimateGas2(
              from: sender,
              to: transaction.to,
              data: transaction.data,
              value: transaction.value,
              gasPrice: gasPrice,
              maxPriorityFeePerGas: transaction.maxPriorityFeePerGas,
              maxFeePerGas: transaction.maxFeePerGas,
            )
            .then((bigInt) => bigInt.toInt());

    // apply default values to null fields
    final modifiedTransaction = transaction.copyWith(
      value: transaction.value ?? EthAmount.zero(),
      maxGas: maxGas,
      from: sender,
      data: transaction.data ?? Uint8List(0),
      gasPrice: gasPrice,
      nonce: nonce,
    );

    int resolvedChainId;
    if (!loadChainIdFromNetwork) {
      resolvedChainId = chainId!;
    } else {
      final provider2 = client!.getDefaultProvider();
      resolvedChainId =
          await provider2.request<String>('net_version').then(int.parse);
    }

    return _SigningInput(
      transaction: modifiedTransaction,
      credentials: credentials,
      chainId: resolvedChainId,
    );
  }

  Uint8List _signTransaction(
    EthTransaction2 transaction,
    Credentials c,
    int? chainId,
  ) {
    if (transaction.isEIP1559 && chainId != null) {
      final encodedTx = LengthTrackingByteSink();
      encodedTx.addByte(0x02);
      encodedTx.add(
        rlp.encode(
            _encodeEIP1559ToRlp(transaction, null, BigInt.from(chainId))),
      );

      encodedTx.close();
      final signature = c.signToEcSignature(
        encodedTx.asBytes(),
        chainId: chainId,
        isEIP1559: transaction.isEIP1559,
      );

      return uint8ListFromList(
        rlp.encode(
          _encodeEIP1559ToRlp(transaction, signature, BigInt.from(chainId)),
        ),
      );
    }
    final innerSignature = chainId == null
        ? null
        : MsgSignature(BigInt.zero, BigInt.zero, chainId);

    final encoded = uint8ListFromList(
        rlp.encode(_encodeToRlp(transaction, innerSignature)));
    final signature = c.signToEcSignature(encoded, chainId: chainId);

    return uint8ListFromList(rlp.encode(_encodeToRlp(transaction, signature)));
  }

  List<dynamic> _encodeEIP1559ToRlp(
    EthTransaction2 transaction,
    MsgSignature? signature,
    BigInt chainId,
  ) {
    final list = [
      chainId,
      transaction.nonce,
      transaction.maxPriorityFeePerGas!.getInWei,
      transaction.maxFeePerGas!.getInWei,
      transaction.gas,
    ];

    if (transaction.to != null) {
      list.add(transaction.to!.addressBytes);
    } else {
      list.add('');
    }

    list
      ..add(transaction.value?.getInWei)
      ..add(transaction.data);

    list.add([]); // access list

    if (signature != null) {
      list
        ..add(signature.v)
        ..add(signature.r)
        ..add(signature.s);
    }

    return list;
  }

  List<dynamic> _encodeToRlp(
    EthTransaction2 transaction,
    MsgSignature? signature,
  ) {
    final list = [
      transaction.nonce,
      transaction.gasPrice?.getInWei,
      transaction.gas,
    ];

    if (transaction.to != null) {
      list.add(transaction.to!.addressBytes);
    } else {
      list.add('');
    }

    list
      ..add(transaction.value?.getInWei)
      ..add(transaction.data);

    if (signature != null) {
      list
        ..add(signature.v)
        ..add(signature.r)
        ..add(signature.s);
    }

    return list;
  }
}

class _SigningInput {
  _SigningInput({
    required this.transaction,
    required this.credentials,
    this.chainId,
  });

  final EthTransaction2 transaction;
  final Credentials credentials;
  final int? chainId;
}

Uint8List prependTransactionType(int type, Uint8List transaction) {
  return Uint8List(transaction.length + 1)
    ..[0] = type
    ..setAll(1, transaction);
}
