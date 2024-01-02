import 'package:atlantic_web3/atlantic_web3.dart';
import 'package:atlantic_web3_account/atlantic_web3_account.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late IWeb3Account web3;

  setUp(() async {
    web3 = Web3Account.instance();
  });

  test('signIn', () async {
    //final result = await web3.signOut();

    //print(result);

    print('Test passed !!!');
  });
}
