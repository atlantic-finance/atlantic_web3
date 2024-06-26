import 'package:atlantic_web3/atlantic_web3.dart';
import 'package:flutter_test/flutter_test.dart';

// https://github.com/ethereum/wiki/wiki/JSON-RPC#the-default-block-parameter
const blockParameters = {
  'latest': EthBlockNum.current(),
  'earliest': EthBlockNum.genesis(),
  'pending': EthBlockNum.pending(),
  '0x40': EthBlockNum.exact(64),
};

void main() {
  test('block parameters encode', () {
    blockParameters.forEach((encoded, block) {
      expect(block.toBlockParam(), encoded);
    });
  });

  test('pending block param is pending', () {
    expect(const EthBlockNum.pending().isPending, true);
  });
}
