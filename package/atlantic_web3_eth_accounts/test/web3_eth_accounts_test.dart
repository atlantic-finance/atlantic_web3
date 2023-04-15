import 'package:atlantic_web3_eth_accounts/atlantic_web3_eth_accounts.dart';
import 'package:atlantic_web3_providers_http/atlantic_web3_providers_http.dart';
import 'package:test/test.dart';

void main() {
  late Web3Accounts web3;

  setUp(() async {
    web3 = Web3Accounts(HttpProvider('http://localhost:7545'));
  });
}
