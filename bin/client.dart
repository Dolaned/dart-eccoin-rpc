import 'package:logger/logger.dart';

import 'parser.dart';
import 'requester.dart';

const networks = {'mainnet': 19119, 'regtest': 40001, 'testnet': 30001};

var logger = Logger(
  printer: PrettyPrinter(),
);

class Client {
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
}
