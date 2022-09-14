import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'Exceptions/http_exception.dart';
import 'Exceptions/rpc_exception.dart';

class RPCClient {
  String host;
  int port;
  String username;
  String password;
  bool useSSL;

  RPCClient({
    required this.host,
    required this.port,
    required this.username,
    required this.password,
    required this.useSSL,
  });

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
      List<dynamic>? args = [];
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
      List<dynamic>? args = [];
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

  Future<dynamic> call(var methodName, [var params]) async {
    // Build rpc auth headers.
    var client = RetryClient(http.Client());
    String basicAuth =
        'Basic ${base64.encode(utf8.encode('$username:$password'))}';

    var headers = {
      'Content-Type': 'application/json',
      'authorization': basicAuth
    };

    var url = getConnectionString();
    var body = {
      'jsonrpc': '2.0',
      'method': methodName,
      'params': params ?? [],
      'id': '1'
    };

    try {
      var response = await client.post(
        Uri.parse(url),
        body: json.encode(body),
        headers: headers,
      );

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
        case HttpStatus.unauthorized:
        case HttpStatus.forbidden:
          throw HTTPException(
            code: response.statusCode,
            message: 'Unauthorized',
          );
        case HttpStatus.internalServerError:
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
      // rethrow;
    } finally {
      client.close();
    }
  }
}
