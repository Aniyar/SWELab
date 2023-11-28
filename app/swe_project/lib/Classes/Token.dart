import 'package:http/http.dart';
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
