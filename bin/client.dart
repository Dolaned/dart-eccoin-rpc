import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

import 'parser.dart';
import 'requester.dart';

const networks = {'mainnet': 19119, 'regtest': 40001, 'testnet': 30001};

var logger = Logger(
  printer: PrettyPrinter(),
);

class Client extends http.BaseClient {
  List agentOptions;
  bool headers;
  String host;
  Logger logger;
  String network;
  String password;
  int port;
  bool ssl;
  int timeout;
  String username;
  String version;
  Parser parser;
  Requester requester;
  final Map _data = {};

  Client({
    this.agentOptions,
    this.headers = false,
    this.host = 'localhost',
    this.logger,
    this.network = 'mainnet',
  }) {
    if (!networks.keys.contains(network)) {
      throw Exception('Invalid network name $network');
    }
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    print(invocation.positionalArguments);
    if (invocation.isGetter) {
      var ret = invocation.memberName.toString();
      if (ret != null) {
        return ret;
      } else {
        super.noSuchMethod(invocation);
      }
    }
    if (invocation.isSetter) {
      _data[invocation.memberName.toString().replaceAll('=', '')] =
          invocation.positionalArguments.first;
    } else {
      super.noSuchMethod(invocation);
    }
  }

  Client prepareConnection() {}

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    // TODO: implement send
    throw UnimplementedError();
  }
}
