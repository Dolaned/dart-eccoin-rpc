import 'dart:io';
import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:http_auth/http_auth.dart' as http_auth;
import 'package:http/http.dart';
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
      var s = invocation.memberName.toString();
      s = s.substring(8, s.length - 2);
      var ret = s.toLowerCase();
      return call(ret, []);
    }

    if (invocation.isSetter) {
      var s = invocation.memberName.toString();
      s = s.substring(8, s.length - 2);
      var method = s.toLowerCase();
      var args = [];
      if (invocation.positionalArguments.length > 1) {
        args = invocation.positionalArguments;
      } else {
        if (invocation.positionalArguments.first is List) {
          args = invocation.positionalArguments.first;
        } else {
          args = [invocation.positionalArguments.first];
        }
      }
      return call(method, args);
    }

    if (invocation.isMethod) {
      var s = invocation.memberName.toString();
      s = s.substring(8, s.length - 2);
      var method = s.toLowerCase();
      var args = [];
      if (invocation.positionalArguments.length > 1) {
        args = invocation.positionalArguments;
      } else {
        if (invocation.positionalArguments.first is List) {
          args = invocation.positionalArguments.first;
        } else {
          args = [invocation.positionalArguments.first];
        }
      }
      return call(method, args);
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

  Future<dynamic> call(var methodName, var params) async {
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

    try {
      var response =
          await client.post(url, body: json.encode(body), headers: headers);

      switch (response.statusCode) {
        case HttpStatus.ok:
          var body = json.decode(response.body);
          if (body['error'] != null) {
            var error = body['error']['message'];
            throw RPCException(
              errorCode: error['code'],
              errorMsg: error['message'],
              method: methodName,
              params: params,
            );
          }
          return body['result'];
          break;
        case HttpStatus.unauthorized:
        case HttpStatus.forbidden:
          throw HTTPException(
              code: response.statusCode, message: 'Unauthorized');
        case HttpStatus.internalServerError:
          if (response.body != null) {
            var body = json.decode(response.body);
            if (body['error'] != null) {
              var error = body['error'];
              throw RPCException(
                errorCode: error['code'],
                errorMsg: error['message'],
                method: methodName,
                params: params,
              );
            }
          }
          throw HTTPException(
            code: response.statusCode,
            message: 'Internal Server Error',
          );
        default:
          throw HTTPException(
            code: response.statusCode,
            message: 'Internal Server Error',
          );
      }
    } on SocketException catch (e) {
      throw HTTPException(
        code: 500,
        message: e.message,
      );
    } catch (e) {
      rethrow;
    }
  }
}
