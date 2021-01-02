import 'dart:io';
import 'dart:mirrors';
import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:http_auth/http_auth.dart' as http_auth;

const networks = {'mainnet': 19119, 'regtest': 40001, 'testnet': 30001};

var logger = Logger(
  printer: PrettyPrinter(),
);

class Client {
  String host;
  int port;
  String username;
  String password;
  String network;

  Logger logger;

  Client({this.host, this.port, this.network, this.username, this.password}) {
    port = networks['mainnet'];
    host ??= '127.0.0.1';
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    // print(invocation.positionalArguments);
    if (invocation.isGetter) {
      var ret = MirrorSystem.getName(invocation.memberName);
      ret = ret.toLowerCase();
      return prepareConnection(ret, []);
    }

    if (invocation.isSetter) {
      var ret = MirrorSystem.getName(invocation.memberName);
      ret = ret.toLowerCase();
      return prepareConnection(ret, invocation.positionalArguments.first);
    }
  }

  Future<dynamic> prepareConnection(var methodName, var params) async {
    var client = http_auth.BasicAuthClient('yourusername', 'yourpassword');
    var headers = {'Content-Type': 'application/json'};
    var url = 'http://$host:$port';
    var body = {
      'jsonrpc': '2.0',
      'method': methodName,
      'params': params,
      'id': '1'
    };

    var response =
        await client.post(url, body: json.encode(body), headers: headers);

    if (response.statusCode == HttpStatus.ok) {
      var result = json.decode(response.body)['result'];
      return result;
    } else if (response.statusCode == HttpStatus.unauthorized) {
      throw http.ClientException('not authorized');
    }
    return {};
  }
}
