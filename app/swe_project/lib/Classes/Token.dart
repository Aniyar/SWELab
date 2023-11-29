import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class Token {
  final String token;

  const Token({
    required this.token
  });
  factory Token.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'accessToken': String token
      } =>
          Token(
              token: token
          ),
      _ => throw const FormatException('Failed to load token.'),
    };
  }



}

