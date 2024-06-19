import 'package:atlantic_web3/atlantic_web3.dart';
import 'package:sprintf/sprintf.dart';

extension StringExtension on String {
  String format(var arguments) => sprintf(this, arguments);

  Boolean equals(String o) {
    return toString() == o;
  }

  Integer parseInt() {
    return Double.parse(this).toInt();
  }

  Boolean isNumeric() {
    try {
      Double.parse(this);
    } on FormatException {
      return false;
    }
    return true;
  }

  Boolean isDate() {
    try {
      DateTime.parse(this);
    } on FormatException {
      return false;
    }
    return true;
  }
}
