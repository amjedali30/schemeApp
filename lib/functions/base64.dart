import 'dart:convert';

String encodeJsonToBase64(Map<String, dynamic> jsonData) {
  String jsonString = '';
  String base64String = '';

  jsonString = jsonEncode(jsonData);
  base64String = base64Encode(utf8.encode(jsonString));

  return base64String;
}
