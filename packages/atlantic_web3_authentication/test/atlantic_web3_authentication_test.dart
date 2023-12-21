import 'package:atlantic_web3_authentication/atlantic_web3_authentication.dart';
import 'package:web3_providers_http/web3_providers_http.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Web3Accounts web3;

  setUp(() async {
    web3 = Web3Accounts(HttpProvider('http://localhost:7545'));
  });
}
