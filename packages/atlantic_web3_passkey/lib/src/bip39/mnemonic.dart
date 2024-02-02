import 'package:atlantic_web3/atlantic_web3.dart';

class Mnemonic implements IMnemonic {
  late List<String> _words;

  // ignore: unused_element
  Mnemonic._();

  // Create from list of words
  Mnemonic.from(List<String> words) {
    assert(
      (words.length % 3) == 0 && words.length >= 12 && words.length <= 32,
      'The words length must be 12, 15, 18, 21 or 24',
    );
    _words = words;
  }

  // Create from string
  Mnemonic.fromString(String str) {
    final List<String> words = str.split(' ');
    assert(
      (words.length % 3) == 0 && words.length >= 12 && words.length <= 32,
      'The words length must be 12, 15, 18, 21 or 24',
    );
    _words = words;
  }

  // Get list of words
  @override
  List<String> getWords() {
    return _words;
  }

  @override
  StringBuffer getStringBuffer() {
    final buffer = StringBuffer();
    for (var i = 0; i < _words.length; i++) {
      buffer.write(_words.elementAt(i));
      if (i < _words.length - 1) {
        buffer.write(' ');
      }
    }
    return buffer;
  }

}
