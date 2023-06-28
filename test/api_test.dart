import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  test('API Test', () async {
    final response = await http.get(Uri.parse('https://randomuser.me/api'));
    expect(response.statusCode, 200); // Check if the response status code is 200 (OK)

    final jsonResponse = json.decode(response.body);
    final message = jsonResponse['message'];

    expect(message, 'IS Passed'); // Check if the message is not null
    // Add more assertions as needed to check the data from the API response
  });
}