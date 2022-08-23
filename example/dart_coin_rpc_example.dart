import 'package:dart_coin_rpc/dart_coin_rpc.dart';

void main() async {
  RPCClient client = RPCClient(
    username: 'rpc',
    password: 'password',
    port: 9902,
    host: '127.0.0.1',
    useSSL: false,
  );

  var res = await client
      .call('validateaddress', ["p92W3t7YkKfQEPDb7cG9jQ6iMh7cpKLvwK"]) as Map;
  assert(res["isvalid"] == true);
}
