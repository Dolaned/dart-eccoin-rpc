import 'dart:convert';

List getRpcResult({Map body, headers = false, response}) {
  if (body['error'] != null) {
    throw Exception(body['error']);
  }

  if (!body.keys.contains('result')) {
    throw Exception('Missing Result on the RPC call');
  }

  if (headers) {
    return [body['result'], response['headers']];
  }

  return body['result'];
}

class Parser {
  var headers;

  Parser({this.headers});

  List rpc([response, body]) {
    if (body is String &&
        response.headers != 'application/json' &&
        response.statusCode != 200) {
      throw Exception(response.statusCode);
    }

    var bodyParsed = jsonDecode(body);

    if (!bodyParsed is List) {
      return getRpcResult(
        body: bodyParsed,
        headers: headers,
        response: response,
      );
    }

    final batch = bodyParsed.map((key, value) {
      try {
        return getRpcResult(body: response, headers: false, response: response);
      } catch (e) {
        return e;
      }
    });

    if (headers) {
      return [batch, response.headers];
    }

    return batch;
  }
}
