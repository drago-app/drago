import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';
import './gfycat_model.dart';

class GfycatApiProvider {
  Client client = Client();
  final _baseUrl = "https://api.gfycat.com/v1/gfycats";

  Future<GfycatModel> fetchGfycat({@required String url}) async {
    final response = await client.get("$_baseUrl" + _parsedURL(url));
    print("GIFYCAT FINAL URL --- " + _baseUrl + _parsedURL(url));
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return GfycatModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load gfycat');
    }
  }

  String _parsedURL(String url) {
    var name = url.substring(url.lastIndexOf("/"),
        url.length /*- url.lastIndexOf("/")*/); //? this may be incorrect
    if (!name.startsWith("/")) {
      name = "/" + name;
    }
    if (name.contains("-")) {
      name = name.split("-")[0];
    }
    return name.split(".")[0];
  }
}
