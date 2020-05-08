import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:helius/classes/xkcd_model.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';

class XkcdApiProvider {
  Client client = Client();
  // final _apiKey = '802b2c4b88ea1183e50e6b285a27696e';
  final _baseUrl = "info.0.json";

  Future<XkcdModel> fetchXkcd({@required String url}) async {
    final response = await client.get(_parsedURL(url));
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return XkcdModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load gfycat');
    }
  }

  String _parsedURL(String url) {
    if (!url.endsWith('/')) {
      url += '/';
    }
    return url += _baseUrl;
  }
}
