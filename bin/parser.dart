
List getRpcResult({Map body, headers = false, response}) {
  if(body['error'] != null) {
    throw Exception(body['error']);
  }

  if(!body.keys.contains('result')) {
    throw Exception('Missing Result on the RPC call');
  }

  if(headers) {
    return [
      body['result'], response['headers']
    ];
  }

  return body['result'];
}

class Parser {
  Map headers;

  Parser({this.headers});

  rpc
}
