import 'dart:convert';

import 'package:http/http.dart' as http;

abstract class HttpService {
  Future<dynamic> getRequest(
      {String? uri, Map<String, String>? queryParameters}) async {
    http.Response response =
        await http.get(Uri.parse(uri!), headers: queryParameters);
    print(response.body);
    var decoded = jsonDecode(response.body);
    return decoded;
  }
}
