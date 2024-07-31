import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart'; // For using compute

import '../constant.dart';

class JwtHelper {
  /// Encodes the header and payload into a JWT token using compute for isolation
  Future<String> encode(String header, String payload) async {
    return compute(_encodeIsolate, {'header': header, 'payload': payload});
  }

  /// Decodes the JWT token and returns the payload using compute for isolation
  Future<Map<String, dynamic>> decode(String token) async {
    return compute(_decodeIsolate, token);
  }

  static String _encodeIsolate(Map<String, String> data) {
    var header = data['header']!;
    var payload = data['payload']!;

    var encodedHeader =
        base64Url.encode(utf8.encode(header)).replaceAll('=', '');
    var encodedPayload =
        base64Url.encode(utf8.encode(payload)).replaceAll('=', '');

    var signature = _generateSignature(encodedHeader, encodedPayload);

    return '$encodedHeader.$encodedPayload.$signature';
  }

  static Map<String, dynamic> _decodeIsolate(String token) {
    var parts = token.split('.');
    if (parts.length != 3) {
      throw const FormatException('Invalid token');
    }

    var encodedHeader = parts[0];
    var encodedPayload = parts[1];
    var signature = parts[2];

    var expectedSignature = _generateSignature(encodedHeader, encodedPayload);

    if (signature != expectedSignature) {
      throw const FormatException('Invalid signature');
    }

    var decodedPayload =
        utf8.decode(base64Url.decode(_addBase64Padding(encodedPayload)));
    return json.decode(decodedPayload);
  }

  /// Generates the signature for the JWT token
  static String _generateSignature(String header, String payload) {
    var key = utf8.encode(secret);
    var bytes = utf8.encode('$header.$payload');

    var hmac = Hmac(sha256, key);
    var digest = hmac.convert(bytes);

    // Use base64Url encoding and remove any padding
    return base64Url.encode(digest.bytes).replaceAll('=', '');
  }

  /// Adds necessary padding to Base64 URL encoded string
  static String _addBase64Padding(String input) {
    var padLength = (4 - input.length % 4) % 4;
    return input + '=' * padLength;
  }
}
