import 'dart:convert';

import 'package:atlantic_web3/atlantic_web3.dart';
import 'package:flutter_test/flutter_test.dart';

import 'data/example_keystores.dart' as data;

void main() {
  final wallets = json.decode(data.content) as Map;

  wallets.forEach((dynamic testName, dynamic content) {
    test(
      'unlocks wallet $testName',
      () {
        final password = content['password'] as String;
        final privateKey = content['priv'] as String;
        final walletData = content['json'] as Map;

        final wallet = Wallet.fromJson(json.encode(walletData), password);
        expect(bytesToHex(wallet.privateKey.privateKey), privateKey);

        final encodedWallet = json.decode(wallet.toJson()) as Map;

        expect(
          encodedWallet['crypto']['ciphertext'],
          walletData['crypto']['ciphertext'],
        );
      },
      tags: 'expensive',
    );
  });
}
