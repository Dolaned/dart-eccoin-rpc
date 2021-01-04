import 'dart:io';
import 'dart:mirrors';
import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:http_auth/http_auth.dart' as http_auth;

import 'Exceptions/HTTPException.dart';
import 'Exceptions/RPCException.dart';

const networks = {'mainnet': 19119, 'regtest': 40001, 'testnet': 30001};

var logger = Logger(
  printer: PrettyPrinter(),
);

class RPCClient {
  String host;
  int port;
  String username;
  String password;
  String network;
  bool useSSL = false;

  Logger logger;

  RPCClient(
      {this.host,
      this.port,
      this.network,
      this.username,
      this.password,
      this.useSSL}) {
    port = networks['mainnet'];
    host ??= '127.0.0.1';
    useSSL = false;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.isGetter) {
      var ret = MirrorSystem.getName(invocation.memberName);
      ret = ret.toLowerCase();
      return call(ret, []);
    }

    if (invocation.isSetter) {
      var ret = MirrorSystem.getName(invocation.memberName);
      ret = ret.toLowerCase();
      return call(ret, invocation.positionalArguments.first);
    }
  }

  String getConnectionString() {
    var urlString = 'http://';
    if (useSSL) {
      urlString = 'https://';
    }
    return '$urlString$host:$port';
  }

  void readConfigFile() {}

  Future<Map> call(var methodName, var params) async {
    // Build rpc auth headers.
    var client = http_auth.BasicAuthClient(username, password);
    var headers = {'Content-Type': 'application/json'};

    var url = getConnectionString();
    var body = {
      'jsonrpc': '2.0',
      'method': methodName,
      'params': params,
      'id': '1'
    };

    var response =
        await client.post(url, body: json.encode(body), headers: headers);

    switch (response.statusCode) {
      case HttpStatus.ok:
        var body = json.decode(response.body);
        if (body['error'] != null) {
          throw RPCException(
              error: body['error'], method: methodName, params: params);
        }
        return body['result'];
        break;
      case HttpStatus.unauthorized:
      case HttpStatus.forbidden:
        throw HTTPException(code: response.statusCode, message: 'Unauthorized');
      case HttpStatus.internalServerError:
        throw HTTPException(
            code: response.statusCode, message: 'Internal Server Error');
      default:
        throw HTTPException(
            code: response.statusCode, message: 'Internal Server Error');
    }
  }
}
