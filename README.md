<a href="https://pub.dartlang.org/packages/dart_coin_rpc"><img alt="pub version" src="https://img.shields.io/pub/v/dart_coin_rpc?style=flat-squaree"></a>
[![Tests](https://github.com/Vesta-wallet/dart-coin-rpc/actions/workflows/tests.yml/badge.svg)](https://github.com/Vesta-wallet/dart-coin-rpc/action/workflows/tests.yml)

Forked from https://github.com/Dolaned/dart-eccoin-rpc

Small libarary that allows JSON communcation with bitcoin-like RPC servers.

## Supported Coins
- Peercoin 
- Bitcoin
- a lot of Bitcoin clones, please advise 

## Example
```dart
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

```
