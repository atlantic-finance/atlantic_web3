import 'dart:typed_data';

import 'package:atlantic_web3/atlantic_web3.dart' as rlp;
import 'package:atlantic_web3/atlantic_web3.dart';

class Web3Account implements IWeb3Account {
  static const EthBlockNum _defaultBlock = EthBlockNum.current();

  // Instancia privada
  static Web3Account? _instance = null;

  static IWeb3Account instance() {
    if (_instance == null) {
      //provider
      final provider = Web3Client.instance.defaultProvider;

      //singleton
      _instance = Web3Account._(provider);
    }
    return _instance!;
  }

  // Principal
  late final BaseProvider _provider;
  late final FilterEngine _filters;

  Web3Account._(BaseProvider provider) {
    // Principal
    _provider = provider;
    _filters = FilterEngine(_provider);
  }

  String _getBlockParam(EthBlockNum? block) {
    return (block ?? _defaultBlock).toBlockParam();
  }

  /// Gets the balance of the account with the specified address.
  ///
  /// This function allows specifying a custom block mined in the past to get
  /// historical data. By default, [BlockNum.current] will be used.
  @override
  Future<EthAmount> getBalance(EthAccount address,
      {EthBlockNum? atBlock}) async {
    final blockParam = _getBlockParam(atBlock);
    final data = await _provider.request<String>(
      'eth_getBalance',
      [address.hex, blockParam],
    );
    return EthAmount.fromBigInt(EthUnit.wei, hexToBigInt(data));
  }

  /// Signs the given transaction using the keys supplied in the [cred]
  /// object to upload it to the client so that it can be executed.
  ///
  /// Returns a hash of the transaction which, after the transaction has been
  /// included in a mined block, can be used to obtain detailed information
  /// about the transaction.
  Future<String> sendTransaction(
      Passkey cred,
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
      Passkey cred,
      EthTransaction2 transaction, {
        int? chainId = 1,
        bool fetchChainIdFromNetworkId = false,
      }) async {
    final signingInput = await _fillMissingData(
      credentials: cred as PasskeyWithKnownAccount,
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
    EthAccount? from,
    EthAccount? to,
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

  /// Returns the amount of Ether typically needed to pay for one unit of gas.
  ///
  /// Although not strictly defined, this value will typically be a sensible
  /// amount to use.
  @override
  Future<EthAmount> getGasPrice() async {
    final data = await _provider.request<String>('eth_gasPrice');
    return EthAmount.fromBigInt(EthUnit.wei, hexToBigInt(data));
  }

  /// Gets the amount of transactions issued by the specified [address].
  ///
  /// This function allows specifying a custom block mined in the past to get
  /// historical data. By default, [BlockNum.current] will be used.
  @override
  Future<int> getTransactionCount(EthAccount address, {EthBlockNum? atBlock}) {
    final blockParam = _getBlockParam(atBlock);

    return _provider.request<String>(
      'eth_getTransactionCount',
      [address.hex, blockParam],
    ).then((hex) => hexToBigInt(hex).toInt());
  }

  @override
  BaseProvider getDefaultProvider() {
    return _provider;
  }

  Future<_SigningInput> _fillMissingData({
    required PasskeyWithKnownAccount credentials,
    required EthTransaction2 transaction,
    int? chainId,
    bool loadChainIdFromNetwork = false,
    IWeb3Account? client,
  }) async {
    if (loadChainIdFromNetwork && chainId != null) {
      throw ArgumentError(
        "You can't specify loadChainIdFromNetwork and specify a custom chain id!",
      );
    }

    final sender = transaction.from ?? credentials.getEthAccount();
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
      Passkey c,
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

  Uint8List prependTransactionType(int type, Uint8List transaction) {
    return Uint8List(transaction.length + 1)
      ..[0] = type
      ..setAll(1, transaction);
  }

}

class _SigningInput {
  _SigningInput({
    required this.transaction,
    required this.credentials,
    this.chainId,
  });

  final EthTransaction2 transaction;
  final Passkey credentials;
  final int? chainId;
}
