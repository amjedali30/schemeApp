import 'dart:convert';
import 'package:crypto/crypto.dart';

String convertToSHA256(String input) {
  var bytes;
  var digest;

  bytes = utf8.encode(input);
  digest = sha256.convert(bytes);

  return digest.toString();
}
